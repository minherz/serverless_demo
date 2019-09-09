package main

import (
	"context"
	"fmt"
	"html/template"
	"io"
	"log"
	"net/http"
	"os"
	"path/filepath"

	"cloud.google.com/go/storage"
	"google.golang.org/appengine"
)

var (
	storageClient         *storage.Client
	indexTmpl, uploadTmpl *template.Template
	bucketName            string
)

func main() {
	// Perform required setup steps for the application to function.
	if err := setup(context.Background()); err != nil {
		log.Fatalf("setup: %v", err)
	}

	http.HandleFunc("/", formHandler)
	http.HandleFunc("/upload", uploadHandler)

	appengine.Main()
}

// setup executes per-instance one-time warmup and initialization actions.
func setup(ctx context.Context) error {
	var err error
	if storageClient, err = storage.NewClient(ctx); err != nil {
		return err
	}
	indexTmpl = template.Must(
		template.ParseFiles(filepath.Join("templates", "index.html")))
	if indexTmpl == nil {
		return fmt.Errorf("failed to parse 'index.html'")
	}
	uploadTmpl = template.Must(
		template.ParseFiles(filepath.Join("templates", "upload.html")))
	if uploadTmpl == nil {
		return fmt.Errorf("failed to parse 'upload.html")
	}
	bucketName = os.Getenv("INPUT_BUCKET_NAME")
	if bucketName == "" {
		return fmt.Errorf("INPUT_BUCKET_NAME has to be defined")
	}
	return nil
}

func formHandler(w http.ResponseWriter, r *http.Request) {
	if err := indexTmpl.Execute(w, nil); err != nil {
		log.Printf("Error executing template: %v", err)
		http.Error(w, "Internal server error", http.StatusInternalServerError)
	}
}

func uploadHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != "POST" {
		http.Error(w, "", http.StatusMethodNotAllowed)
		return
	}

	ctx := appengine.NewContext(r)

	f, fh, err := r.FormFile("file_uri")
	if err != nil {
		msg := fmt.Sprintf("Could not get file: %v", err)
		http.Error(w, msg, http.StatusBadRequest)
		return
	}
	defer f.Close()

	sw := storageClient.Bucket(bucketName).Object(fh.Filename).NewWriter(ctx)
	if _, err := io.Copy(sw, f); err != nil {
		msg := fmt.Sprintf("Could not write file: %v", err)
		http.Error(w, msg, http.StatusInternalServerError)
		return
	}

	if err := sw.Close(); err != nil {
		msg := fmt.Sprintf("Could not put file: %v", err)
		http.Error(w, msg, http.StatusInternalServerError)
		return
	}

	type uploadData struct {
		FileName string
	}
	data := uploadData{
		FileName: sw.Attrs().Name,
	}

	if err := uploadTmpl.Execute(w, data); err != nil {
		log.Printf("Error executing template: %v", err)
		http.Error(w, "Internal server error", http.StatusInternalServerError)
	}
}

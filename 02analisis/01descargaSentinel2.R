# Open an interactive section
if (interactive()) {
  sen2r()
}

# Launch a processing from a saved JSON file (here we use an internal function
# to create a testing json file - this is not intended to be used by final users)
json_path <- build_example_param_file()

if (is_gcloud_configured()) {
  out_paths_2 <- sen2r(json_path)
} else {
  out_paths_2 <- character(0)
}
# Notice that passing the path of a JSON file results in launching
# a session without opening the gui, unless gui = TRUE is passed.

# Launch a processing using function arguments
safe_dir <- file.path(dirname(attr(load_binpaths(), "path")), "safe")
out_dir_3 <- tempfile(pattern = "Barbellino_")
if (is_gcloud_configured()) {
  out_paths_3 <- sen2r(
    gui = FALSE,
    server = "gcloud",
    step_atmcorr = "l2a",
    extent = system.file("extdata/vector/barbellino.geojson", package = "sen2r"),
    extent_name = "Barbellino",
    timewindow = as.Date("2020-08-01"),
    list_prods = c("TOA","BOA","SCL","OAA"),
    list_indices = c("NDVI","MSAVI2"),
    list_rgb = c("RGB432T", "RGB432B", "RGB843B"),
    mask_type = "cloud_medium_proba",
    max_mask = 80,
    path_l1c = safe_dir,
    path_l2a = safe_dir,
    path_out = out_dir_3
  )
} else {
  out_paths_3 <- character(0)
}

if (is_gcloud_configured()) {
  
  # Show outputs (loading thumbnails)
  
  # Generate thumbnails names
  thumb_3 <- file.path(dirname(out_paths_3), "thumbnails", gsub("tif$", "jpg", basename(out_paths_3)))
  thumb_3[grep("SCL", thumb_3)] <-
    gsub("jpg$", "png", thumb_3[grep("SCL", thumb_3)])
  
  oldpar <- par(mfrow = c(1,2), mar = rep(0,4))
  image(stars::read_stars(thumb_3[grep("BOA", thumb_3)]), rgb = 1:3, useRaster = TRUE)
  image(stars::read_stars(thumb_3[grep("SCL", thumb_3)]), rgb = 1:3, useRaster = TRUE)
  
  par(mfrow = c(1,2), mar = rep(0,4))
  image(stars::read_stars(thumb_3[grep("MSAVI2", thumb_3)]), rgb = 1:3, useRaster = TRUE)
  image(stars::read_stars(thumb_3[grep("NDVI", thumb_3)]), rgb = 1:3, useRaster = TRUE)
  
  par(mfrow = c(1,2), mar = rep(0,4))
  image(stars::read_stars(thumb_3[grep("RGB432B", thumb_3)]), rgb = 1:3, useRaster = TRUE)
  image(stars::read_stars(thumb_3[grep("RGB843B", thumb_3)]), rgb = 1:3, useRaster = TRUE)
  
  par(oldpar)
  
}


## Not run: 

# Launch a processing based on a JSON file, but changing some parameters
# (e.g., the same processing on a different extent)
out_dir_4 <- tempfile(pattern = "Scalve_")
out_paths_4 <- sen2r(
  param_list = json_path,
  extent = system.file("extdata/vector/scalve.kml", package = "sen2r"),
  extent_name = "Scalve",
  path_out = out_dir_4
)


## End(Not run)
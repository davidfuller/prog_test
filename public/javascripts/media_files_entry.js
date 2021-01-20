//contains js for media file entry
var myForm = document.getElementById("media_file_name");
myForm.addEventListener("focusout", getInputValue);

myForm.addEventListener('keydown', function(e) {
  if (e.keyIdentifier == 'U+000A' || e.keyIdentifier == 'Enter' || e.keyCode == 13) {
      if (e.target.name == 'media_file[name]'){
        document.getElementById("media_file_filename").focus();
        e.preventDefault();
        return false;
      }
  }
}, true);

function getInputValue() {
  let prefix = document.getElementById("media_file_next_prefix").value;
  let inputVal = document.getElementById("media_file_name").value;
  var filenameField = document.getElementById("media_file_filename");
  var filename = (prefix + inputVal).toUpperCase() + ".tga";
  var filename_normalised = filename.normalize("NFD").replace(/[\u0300-\u036f]/g, "")
  filenameField.value = filename_normalised;
}
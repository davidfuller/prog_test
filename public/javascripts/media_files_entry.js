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
  var filename = (prefix + inputVal).toUpperCase();
  var filename_normalised = sanitize(filename) + ".tga";
  filenameField.value = filename_normalised;
}

var illegalRe = /[\/\?<>\\:\*\|"]/g;
var controlRe = /[\x00-\x1f\x80-\x9f]/g;
var reservedRe = /^\.+$/;
var windowsReservedRe = /^(con|prn|aux|nul|com[0-9]|lpt[0-9])(\..*)?$/i;
var windowsTrailingRe = /[\. ]+$/;

function sanitize(input) {
  replacement = "_"
  var sanitized = input
    .replace("Ø", "O")
    .replace("Æ","AE")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(illegalRe, replacement)
    .replace(controlRe, replacement)
    .replace(reservedRe, replacement)
    .replace(windowsReservedRe, replacement)
    .replace(windowsTrailingRe, replacement)
    .replace(/[^a-z0-9]/gi, replacement)
    .replace(/\s+/g, replacement)
    .replace(/_+/g,replacement);
  return sanitized;
}

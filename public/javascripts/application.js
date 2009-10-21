// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function setDefaultValue(obj, value){
  if(obj["value"]==''){
    obj["style"]["color"] = "#7f7f7f"
    obj["value"]=value;
  }
}

function unsetDefaultValue(obj, value){
  if(obj["value"]==value){
    obj["value"]=''
    obj["style"]["color"] = "#000000"
  }
}
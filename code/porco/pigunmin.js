var scrollbar = new Control.ScrollBar('scrollbar_content','scrollbar_track','scrollbtnup','scrollbtndown');
var cureval = 0;
var scrollup = function(){scrollbar.scrollBy(-24);};
var scrolldown = function(){scrollbar.scrollBy(24);};

$('scrollbtndown').observe('mousedown',function(event){
    scrollbar.scrollBy(24);
    if(cureval!=0)
    {
        window.self.clearInterval(cureval);
    }
    cureval = window.self.setInterval(scrolldown,250);
    event.stop();
});

$('scrollbtndown').observe('mouseup',function(event){
    if(cureval!=0)
    {
        window.self.clearInterval(cureval);
    }
    event.stop();
});

$('scrollbtnup').observe('mousedown',function(event){
    scrollbar.scrollBy(-24);
    if(cureval!=0)
    {
        window.self.clearInterval(cureval);
    }
    cureval = window.self.setInterval(scrollup,250);
    event.stop();
});

$('scrollbtnup').observe('mouseup',function(event){
    if(cureval!=0)
    {
        window.self.clearInterval(cureval);
    }
    event.stop();
});


function redirect() {
    var s = encodeURIComponent("doneRsc")
    window.location = "byond://winset?command=" + s
}

var elem = document.getElementById('scrollbar_content');
var elem_scrollbar = document.getElementById('scrollbar_track');
var E = document.getElementById('scrollbar_container');

elem.onscroll = fixScrollbar

function FI(tmpImg)
{
    tmpImg.src += "?m=" + Math.floor(Math.random() * 10000) ;
}

function fixScrollbar()
{
    if(scrollbar.lastscrollTop != elem.scrollTop)
    {
    scrollbar.scrollTo(elem.scrollTop,0);
    }
}

function imagesReload(){
    var i = Array.from(document.querySelectorAll("img"))

    for(var x = 0; x < i.length; x++){
        i.onerror = function(){return FI(i)}
    }
}


function addButton(content, selector){
    var selected = document.querySelector(selector)

    if(!selected){
        return
    }
    if(selected.innerHTML == content){
        return
    }

    selected.innerHTML = content
    scrollbar.recalculateLayout()
}
function changeButtonContent(content, selector){
    var selected = document.querySelector(selector)
    if(!selected){
        return
    }
    selected.onclick = function (){
        InputMsg(content)
    }
    scrollbar.recalculateLayout()
}

function InputMsg(msgtext)
{
    if(msgtext != "" && msgtext != null)
    {msgtext = msgtext.split("$").join("<br>");}
    
    elem.innerHTML = msgtext;
    scrollbar.recalculateLayout();
}

function changeHTML(selector, content){
    var elem = document.querySelector(selector)
    if(!elem){
        return
    }

    elem.innerHTML = content
}

window.onload = function(){return redirect()}

var p = document.getElementById("pig")
var n = document.getElementById("note")
if(p){
    p.onclick = function(){
        var s = encodeURIComponent("Who")
        window.location = "byond://winset?command=" + s
    }
}
if(n){
    n.onclick = function(){   
        var s = encodeURIComponent("heartpig")
        window.location = "byond://winset?command=" + s
    }
}
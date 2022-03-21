function updateText(tmpdesc){
	
    var elem1 = document.getElementById('INFO');
    var elem2 = document.getElementById('HINTHOLDER');
    if (elem1 == null || elem2 == null) return;
    elem1.innerHTML = tmpdesc;
    if(tmpdesc.length > 2)
    {
        elem2.style.visibility  = "visible";
    }
    else
    {
        elem2.style.visibility  = "hidden";
    }
    
    
}
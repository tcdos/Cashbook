function myfocus() {
	var inputs = document.getElementsByTagName("input"),
	i = inputs.length;
	while (i--) {
		inputs[i].onfocus = function() {
			this.className += " focus";
		};
		inputs[i].onblur = function() {
			this.className = this.className.replace(" focus", "");
		};
	};
};

function showtable() {
    var tablename = document.getElementById("tab");
	var rows = tablename.getElementsByTagName("tr");
    for (var i = 1; i < rows.length; i++) {
        rows[i].bgc = rows[i].style.backgroundColor;
        rows[i].onmouseover = function() {
            this.style.backgroundColor = "#FAFAD2";
        }
        rows[i].onmouseout = function() {
            this.style.backgroundColor = this.bgc;
        }
    }
}

function Pages(){
	myfocus();
	showtable();
}

function showit(str) {
    if (str.style.display == "none") {
        str.style.display = "";
    } else {
        str.style.display = "none";
    }
}
function o(obj) {
    return document.getElementById(obj)
}
function show(id) {
    var obj = o(id) 
	showit(obj)
}
var time = new Date(),
	xhr = new XMLHttpRequest(),
	method = 'GET',
	url = ''
	async,
	user,
	password,
	//header, value,
	body;

xhr.addEventListener("loadstart", function(event){
	console.log("start", this, Utils.timeDiff(time, new Date()).toString());
});

xhr.addEventListener("progress", function(event){
	if (event.lengthComputable){ console.log("progress", event.loaded / event.total * 100, this, Utils.timeDiff(time, new Date()).toString()); }
});

xhr.addEventListener("abort", function(event){
	console.log("abort", this, Utils.timeDiff(time, new Date()).toString());
});

xhr.addEventListener("error", function(event){
	console.error("error", this, Utils.timeDiff(time, new Date()).toString());
});

xhr.addEventListener("load", function(event){
	console.log("load", this, Utils.timeDiff(time, new Date()).toString());
	console.log(this.responseURL, this.status, this.statusText, this.responseType);
});

xhr.addEventListener("timeout", function(event){
	console.log("timeout", this, Utils.timeDiff(time, new Date()).toString());
});

xhr.addEventListener("loadend", function(event){
	console.log("end", this, Utils.timeDiff(time, new Date()).toString());
});

xhr.addEventListener("readystatechange", function(event){
	console.log("readystatechange", this, Utils.timeDiff(time, new Date()).toString());
});

xhr.open(method, url, async, user, password);
//xhr.setRequestHeader(header, value);
xhr.send(body);

/**********************************************************************************************************************************************************/

var time, times = [],
	runs = 0,
	iter = 0,
	xhr = new XMLHttpRequest(),
	method = 'GET',
	url = 'maintenance/getGroups';
	
xhr.addEventListener("loadstart", function(event){
	console.log("Start", this, Utils.timeDiff(time, new Date()).toString());
});

xhr.addEventListener("abort", function(event){
	var _time = Utils.timeDiff(time, new Date());
	console.log("Abort", this, Utils.timeDiff(time, new Date()).toString(), average(), `Run: ${times.length}`);
	console.log(this.responseURL, this.status, this.statusText, this.responseType);
	if (!(iter < runs - 1)){ console.log(`Completed Average Time: ${average()}`); }
});

xhr.addEventListener("error", function(event){
	var _time = Utils.timeDiff(time, new Date());
	times.push(_time);
	console.error("Error", this, Utils.timeDiff(time, new Date()).toString(), average(), `Run: ${times.length}`);
	console.error(this.responseURL, this.status, this.statusText, this.responseType);
	if (iter < runs - 1){ 
		iter++;
		send();
	}
	else { console.log(`Completed Average Time: ${average()}`); }
});

xhr.addEventListener("load", function(event){
	var _time = Utils.timeDiff(time, new Date());
	times.push(_time);
	console.log("Done", this, _time.toString(), average(), `Run: ${times.length}`);
	console.log(this.responseURL, this.status, this.statusText, this.responseType);
	
	if (iter < runs - 1){ 
		iter++;
		send();
	}
	else { console.log(`Completed Average Time: ${average()}`); }
});

function start(_runs, reset){
	if (reset){
		cancel();
		times = [];
	}
	iter = 0;
	runs = _runs || 10;
	send();
};

function cancel(){
	runs = NaN;
	xhr.abort();
};

function send(){
    time = new Date();
    xhr.open(method, url);
    xhr.send();
};

function average(){
	var milli = 0;
	times.forEach(function(t){ milli += t.to_date.getTime() - t.from_date.getTime(); });
	milli = milli / times.length;

	var hours = Math.floor(milli / Utils.milliPerHour );
    milli = milli - (hours * Utils.milliPerHour );

    var minutes = Math.floor(milli / Utils.milliPerMinute );
    milli = milli - (minutes * Utils.milliPerMinute );

    var seconds = Math.floor(milli / 1000 );
    milli = Math.floor(milli - (seconds * Utils.milliPerSecond ));

	return `${hours.toString().padStart(2, "0")}:${minutes.toString().padStart(2, "0")}:${seconds.toString().padStart(2, "0")}.${milli.toString().padStart(3, "0")}`;
};





var xhr = new XMLHttpRequest();
xhr.addEventListener("loadstart", function(event){ console.log("start", this); });
xhr.addEventListener("abort", function(event){ console.log("abort", this); });
xhr.addEventListener("error", function(event){ console.error("error", this); });
xhr.addEventListener("load", function(event){ console.log("load", this); });
xhr.addEventListener("timeout", function(event){ console.log("timeout", this); });
xhr.open('GET', '/jimi/maintenance/queue');
xhr.send();
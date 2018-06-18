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

function calculateAverage(method, url, runs){
	var xhr = new XMLHttpRequest(), time, times = [], iter = 0, errors = 0;
	method = method ? method.toUpperCase() : 'GET';
	url = url || '/';
	runs = runs || 10;
	
	function send(){
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
	
	xhr.addEventListener("loadstart", function(event){
		time = new Date();
		console.log("Start", Utils.timeDiff(time, new Date()).toString());
	});

	xhr.addEventListener("abort", function(event){
		console.log("Aborted", Utils.timeDiff(time, new Date()).toString(), `Run: ${times.length}`);
		runs = NaN;
	});

	xhr.addEventListener("error", function(event){
		errors++;
		console.error("Error", Utils.timeDiff(time, new Date()).toString(), `Run: ${times.length}`);
	});

	xhr.addEventListener("loadend", function(event){
		var timeDiff = Utils.timeDiff(time, new Date());
		times.push(timeDiff);
		console.log("Done", timeDiff.toString(), average(), `Run: ${times.length}`);
		
		if (iter < runs - 1){ 
			iter++;
			send();
		}
		else { console.log(`Completed Average Time: ${average()} with ${errors} error(s).`); }
	});

	send();
}
calculateAverage('GET', '/jimi/maintenance/getGroups1');

/**********************************************************************************************************************************************************/

var xhr = new XMLHttpRequest();
xhr.addEventListener("loadstart", function(event){ console.log("Start", this); });
xhr.addEventListener("timeout", function(event){ console.log("Timeout", this); });
xhr.addEventListener("abort", function(event){ console.log("Aborted", this); });
xhr.addEventListener("error", function(event){ console.error("Error", this); });
xhr.addEventListener("load", function(event){ console.log("Loaded", this); });
xhr.addEventListener("loadend", function(event){ console.log("Done", this); });
xhr.open('GET', '/jimi/maintenance/queue');
xhr.send();





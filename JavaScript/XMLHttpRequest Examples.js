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

function XHRStats(method, url){
	this.method = method ? method.toUpperCase() : 'GET';
	this.url = url || '/';
	
	this.abort = function(){
		this.xhr.abort();
	};
	
	this.run = function(runs){
		this.xhr = new XMLHttpRequest();
		this.time = [];
		runs = runs || 10;
		var $this = this, iter = 0, errors = 0;
	
		this.xhr.addEventListener("loadstart", function(event){
			this.time = new Date();
			console.log("Start - Time: %s, Run: %s", total(), $this.time.length + 1 + errors);
		});

		this.xhr.addEventListener("abort", function(event){
			console.log("Aborted - Time: %s, Run: %s", Utils.timeDiff(this.time, new Date()).toString(),  $this.time.length + errors);
			runs = NaN;
		});

		this.xhr.addEventListener("error", function(event){
			errors++;
			console.error("Error - Time: %s, Run: %s", Utils.timeDiff(this.time, new Date()).toString(),  $this.time.length + errors);
		});

		this.xhr.addEventListener("load", function(event){
			var timeDiff = Utils.timeDiff(this.time, new Date());
			$this.time.push(timeDiff);
			console.log("Loaded - Time: %s, Average: %s, Run: %s", timeDiff.toString(), mean(),  $this.time.length + errors);
		});

		this.xhr.addEventListener("loadend", function(event){
			if (iter < runs - 1){ 
				iter++;
				send();
			}
			else { console.log("Completed - Time: %s, Runs: %s, Errors: %s, Average: %s, Max: %s, Min: %s, Range: %s", total(), $this.time.length + errors, errors, mean(), max(), min(), range()); }
		});
		
		function send(){
			$this.xhr.open($this.method, $this.url);
			$this.xhr.send();
		};
		send();
	};
	
	function total(){
		var milli = 0;
		this.time.forEach(function(t){ milli += t.to_date.getTime() - t.from_date.getTime(); });
		return getTime(milli);
	}
	
	function min(){
		var milli = this.time.map(function(time){ return time.to_date.getTime() - time.from_date.getTime(); }).reduce(function(a, b) {
			return Math.min(a, b);
		});
		return getTime(milli);
	};
	
	function max(){
		var milli = this.time.map(function(time){ return time.to_date.getTime() - time.from_date.getTime(); }).reduce(function(a, b) {
			return Math.max(a, b);
		});
		return getTime(milli);
	};
	
	function mean(){
		var milli = 0;
		this.time.forEach(function(t){ milli += t.to_date.getTime() - t.from_date.getTime(); });
		milli = milli / this.time.length;
		return getTime(milli);
	};
	
	function range(){
		var max = this.time.map(function(time){ return time.to_date.getTime() - time.from_date.getTime(); }).reduce(function(a, b) {
			return Math.max(a, b);
		});
		var min = this.time.map(function(time){ return time.to_date.getTime() - time.from_date.getTime(); }).reduce(function(a, b) {
			return Math.min(a, b);
		});
		var milli = max - min;
		return getTime(milli);
	}
	
	function getTime(milli){
		var hours = Math.floor(milli / Utils.milliPerHour );
		milli = milli - (hours * Utils.milliPerHour );

		var minutes = Math.floor(milli / Utils.milliPerMinute );
		milli = milli - (minutes * Utils.milliPerMinute );

		var seconds = Math.floor(milli / 1000 );
		milli = Math.floor(milli - (seconds * Utils.milliPerSecond ));

		return `${hours.toString().padStart(2, "0")}:${minutes.toString().padStart(2, "0")}:${seconds.toString().padStart(2, "0")}.${milli.toString().padStart(3, "0")}`;
	}
	return this;
};

var stats = XHRStats('GET', '/');
stats.run(100);

/**********************************************************************************************************************************************************/

var xhr = new XMLHttpRequest();
xhr.addEventListener("loadstart", function(event){ console.log("Start", this); });
xhr.addEventListener("timeout", function(event){ console.log("Timeout", this); });
xhr.addEventListener("abort", function(event){ console.log("Aborted", this); });
xhr.addEventListener("error", function(event){ console.error("Error", this); });
xhr.addEventListener("load", function(event){ console.log("Loaded", this); });
xhr.addEventListener("loadend", function(event){ console.log("Done", this); });
xhr.open('POST', '/');
xhr.send();





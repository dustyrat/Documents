// '' ? true : false == false
// null ? true : false == false
// undefined ? true : false == false


// Method Strings
// POST:	Create
// GET:		Read
// PUT:		Update
// DELETE:	Delete

$http({
	method: {string},
	url: {string|TrustedObject},
	params: {Object.<string|Object>},
	data: {string|Object},
	headers: {Object},
	eventHandlers: {Object},
	uploadEventHandlers: {Object},
	xsrfHeaderName: {string},
	xsrfCookieName: {string},
	transformRequest: {function(data, headersGetter)|Array.<function(data, headersGetter)>},
	transformResponse: {function(data, headersGetter, status)|Array.<function(data, headersGetter, status)>},
	paramSerializer: {string|function(Object<string,string>):string},
	cache: {boolean|Object},
	timeout: {number|Promise},
	withCredentials: {boolean},
	responseType: {string}
}).then(function successCallback(response) {
	console.log(response);
}, function errorCallback(response) {
	console.log(response);
});

bootbox.dialog({
	title: "Custom title",
	message: "I am a custom dialog",
	onEscape: function(){ },
	show: true,
	backdrop: true,
	closeButton: true,
	animate: true,
	className: "my-modal",
	buttons: {
		success: {
			label: "Success!",
			className: "btn-success",
			callback: function(){ }
		},
		"Danger!": {
			className: "btn-danger",
			callback: function(){ }
		},
		"Another label": function() { }
	}
});

function getProperty(object, string) {
	var keys = string.replace(/\[(\w+)\]/g, '.$1').replace(/^\./, '').split('.');
	for (var i = 0, n = keys.length; i < n; ++i){
		var key = keys[i];
		if (key in object){ object = object[key]; }
		else { return; }
	}
	return object;
}

var browser = (function browser(){
    var userAgent = window.navigator.userAgent, tem,
    M = userAgent.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i) || [];
    if(/trident/i.test(M[1])){
        tem=  /\brv[ :]+(\d+)/g.exec(userAgent) || [];
        return { name: 'IE', version: tem[1] || '' };
    }
    if(M[1] === 'Chrome'){
        tem = userAgent.match(/\b(OPR|Edge)\/(\d+)/);
        if(tem != null) return tem.slice(1).join(' ').replace('OPR', 'Opera');
    }
    M = M[2] ? [M[1], M[2]] : [window.navigator.appName, window.navigator.appVersion, '-?'];
    if((tem= userAgent.match(/version\/(\d+)/i)) != null) M.splice(1, 1, tem[1]);
    return { name: M[0], version: M[1] };
})();

function generateUUID(){
	var time = typeof performance !== 'undefined' && typeof performance.now === 'function' ? new Date().getTime() + performance.now() : new Date().getTime();
	return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(char){
		var rand = (time + Math.random() * 16) % 16 | 0;
		time = Math.floor(time / 16);
		return (char === 'x' ? rand : (rand & 0x3 | 0x8)).toString(16);
	});
}

function logTime(func){
	function getTime(){ return typeof performance !== 'undefined' && typeof performance.now === 'function' ? performance.now() : new Date().getTime(); }
	var time = getTime();
	try { return func.apply(this, Array.prototype.slice.call(arguments, 1)); }
	finally { console.trace('%s(%o): %.2f ms', arguments[0].name, Array.prototype.slice.call(arguments, 1), getTime() - time); }
}

function Union(array1, array2){
	Array.prototype.push.apply(array1, array2);
	return array1.filter(function(elem, index, self){ return index == indexOf(self, elem); });
}

function Intersection(array1, array2){
	return array1.filter(function(elem, index, self){ return indexOf(array2, elem) > -1; });
}

function Difference(array1, array2){
	return array1.filter(function(elem, index, self){ return indexOf(array2, elem) == -1; });
}

function indexOf(array, obj, key){
	if (!array || array.lenth == 0){ return -1; }
	for(var i = 0; i < array.length; i++){
		if (key && array[i].hasOwnProperty(key) && obj.hasOwnProperty(key) && angular.equals(array[i][key], obj[key])){ return i; }
		else if (angular.equals(array[i], obj)){ return i; }
	}
	return -1;
}

function storageEventHandler(event){
	console.log(event.key, event.oldValue, event.newValue);
}
window.addEventListener('storage', storageEventHandler, false);

function setCookie(name, value, expiration, path){
    var date = new Date();
    date.setTime(date.getTime() + expiration);
    var expires = 'expires=' + date.toUTCString();
    document.cookie = name + '=' + value + ';' + expires + ';path=' + path ? path : '/';
}

function getCookie(name){
	name = name + "=";
    var cookies = document.cookie.split(';');
    for(var i in cookies) {
        var cookie = cookies[i];
        while (cookie.charAt(0) == ' '){ cookie = cookie.substring(1); }
        if (cookie.indexOf(name) == 0){ return cookie.substring(name.length, cookie.length); }
    }
    return "";
}

function getCookies(){
	var cookies = document.cookie.split(';');
	var obj = {};
	for (var i in cookies){
		var keyValue = cookies[i].split('=');
		obj[keyValue[0]] = keyValue[1];
	}
	return obj;
}

function checkCookie(){
    var user = getCookie("username");
    if (user != "") {
        alert("Welcome again " + user);
    } else {
        user = prompt("Please enter your name:", "");
        if (user != "" && user != null) {
            setCookie("username", user, 365);
        }
    }
}

if (window.EventSource !== undefined){
	var eventSource = new EventSource(baseUrl + 'navigation/getCountStream');
	eventSource.onmessage = function(event){
		console.log('Message: %o', event, event.data);
		var data;
		try {
			data = JSON.parse(event.data);
		}
		catch (exception){
			data = event.data;
		}
	};
	
	eventSource.onerror = function(event){
		switch(event.target.readyState){
			case EventSource.CONNECTING:
				console.log('Reconnecting to %s', eventSource.url);
				break;
			case EventSource.CLOSED:
				console.error('Connection to %s failed', eventSource.url);
				break;
		}
	};
	
	$timeout(function(){
		console.log('Closing Connection %s', eventSource.url);
		eventSource.close();
	}, 60000);
}
else {
	
}

function get(obj, key) {
    return path.split('.').reduce(function(prev, curr) { return prev ? prev[curr] : undefined }, obj || self)
}
var counts = {};
angular.forEach(jQuery.unique(original.map(function(item) { return get(item, key) || $scope.missing; })).sort(), function(value){
	counts[value] = original.filter(function(item){ return (get(item, key) || $scope.missing) == value; }).length;
)


		
var data = JSON.stringify({ pwdAllowUserChange: false });
var xhr = new XMLHttpRequest();
xhr.open('PUT', baseUrl + 'updatePwdPolicy', true);
xhr.setRequestHeader('Content-type','application/json; charset=utf-8');
xhr.setRequestHeader('X-Requested-With','XMLHttpRequest');
xhr.onload = function () {
	try {
		var response = JSON.parse(xhr.response);
		if (xhr.readyState == 4 && xhr.status == "200"){ console.log(response); }
		else { console.error(response); }
	}
	catch (exception){ Prompt(xhr.response); }
}
xhr.send(data);
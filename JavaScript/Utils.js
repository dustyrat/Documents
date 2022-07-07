class Utils {
	static get browser() {
		var userAgent = window.navigator.userAgent,
			temp,
			match = userAgent.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*([\d\.]+)/i) || [];
		if (/trident/i.test(match[1])) {
			temp = /\brv[ :]+([\d\.]+)/g.exec(userAgent) || [];
			return { name: 'IE', version: temp[1] || '' };
		}
		if (match[1] === 'Chrome') {
			temp = userAgent.match(/\b(OPR|Edge)\/([\d\.]+)/);
			if (temp !== null) { return temp.slice(1).join(' ').replace('OPR', 'Opera'); }
		}
		match = match[2] ? [match[1], match[2]] : [window.navigator.appName, window.navigator.appVersion, '-?'];
		if ((temp = userAgent.match(/version\/([\d\.]+)/i)) !== null) { match.splice(1, 1, temp[1]); }
		return { name: match[0], version: match[1] };
	};

	static htmlEncode(string) {
		return $('<div>').text(string).html();
	}

	static setCookie(name, value, expiration, path) {
		var date = new Date();
		date.setTime(date.getTime() + expiration);
		var expires = 'expires=' + date.toUTCString();
		document.cookie = `${name}=${value};${expires};path=${path ? path : '/'}`;
	};

	static getCookie(name) {
		name = name + "=";
		var cookies = document.cookie.split(';');
		for (var i in cookies) {
			var cookie = cookies[i];
			while (cookie.charAt(0) === ' ') { cookie = cookie.substring(1); }
			if (cookie.indexOf(name) === 0) { return cookie.substring(name.length, cookie.length); }
		}
		return "";
	};

	static getTime() {
		return typeof performance !== 'undefined' && typeof performance.now === 'function' ? performance.now() : new Date().getTime();
	};

	static logTime(func) {
		var time = Utils.getTime();
		try { return func.apply(this, Array.prototype.slice.call(arguments, 1)); }
		finally { console.info('%s(%o): %s', arguments[0].name, Array.prototype.slice.call(arguments, 1), Utils.timeDiff(new Date(Utils.getTime()), new Date(time)).toString()); }
	};


	static generateUUID() {
		var time = Utils.getTime();
		return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (char) {
			var rand = (time + Math.random() * 16) % 16 | 0;
			time = Math.floor(time / 16);
			return (char === 'x' ? rand : (rand & 0x3 | 0x8)).toString(16);
		});
	};

	static get milliPerSecond() { return 1000; };
	static get milliPerMinute() { return Utils.secondsPerMinute * Utils.milliPerSecond; };
	static get milliPerHour() { return Utils.minutesPerHour * Utils.milliPerMinute; };
	static get milliPerDay() { return Utils.hoursPerDay * Utils.milliPerHour; };
	static get milliPerWeek() { return Utils.daysPerWeek * Utils.milliPerDay; };
	static get milliPerMonth() { return Utils.daysPerMonth * Utils.milliPerDay; };
	static get milliPerYear() { return Utils.daysPerYear * Utils.milliPerDay; };

	static get secondsPerMinute() { return 60; };
	static get secondsPerHour() { return Utils.minutesPerHour * Utils.secondsPerMinute; };
	static get secondsPerDay() { return Utils.hoursPerDay * Utils.secondsPerHour; };
	static get secondsPerWeek() { return Utils.daysPerWeek * Utils.secondsPerDay; };
	static get secondsPerMonth() { return Utils.daysPerMonth * Utils.secondsPerDay; };
	static get secondsPerYear() { return Utils.daysPerYear * Utils.secondsPerDay; };

	static get minutesPerHour() { return 60; };
	static get minutesPerDay() { return Utils.hoursPerDay * Utils.minutesPerHour; };
	static get minutesPerWeek() { return Utils.daysPerWeek * Utils.minutesPerDay; };
	static get minutesPerMonth() { return Utils.daysPerMonth * Utils.minutesPerDay; };
	static get minutesPerYear() { return Utils.daysPerYear * Utils.minutesPerDay; };

	static get hoursPerDay() { return 24; };
	static get hoursPerWeek() { return Utils.daysPerWeek * Utils.hoursPerDay; };
	static get hoursPerMonth() { return Utils.daysPerMonth * Utils.hoursPerDay; };
	static get hoursPerYear() { return Utils.daysPerYear * Utils.hoursPerDay; };

	static get daysPerWeek() { return 7; };
	static get daysPerMonth() { return 30.436806; };
	static get daysPerYear() { return 365.241898; };

	static get monthsPerYear() { return 12.000008; };

	static timeDiff(from_date, to_date) {
		var milli = to_date.getTime() - from_date.getTime();

		var hours = Math.floor(milli / Utils.milliPerHour);
		milli = milli - (hours * Utils.milliPerHour);

		var minutes = Math.floor(milli / Utils.milliPerMinute);
		milli = milli - (minutes * Utils.milliPerMinute);

		var seconds = Math.floor(milli / 1000);
		milli = Math.floor(milli - (seconds * Utils.milliPerSecond));

		return {
			from_date: from_date,
			to_date: to_date,
			hours: hours,
			minutes: minutes,
			seconds: seconds,
			milli: milli,
			toString: function () {
				return `${hours.toString().padStart(2, "0")}:${minutes.toString().padStart(2, "0")}:${seconds.toString().padStart(2, "0")}.${milli.toString().padStart(3, "0")}`;
			}
		};
	};

	static dateDiff(from_date, to_date) {
		var milli = to_date.getTime() - from_date.getTime();

		var years = Math.floor(milli / Utils.milliPerYear);
		milli = milli - (years * Utils.milliPerYear);

		var months = Math.floor(milli / Utils.milliPerMonth);
		milli = milli - (months * Utils.milliPerMonth);

		var weeks = Math.floor(milli / Utils.milliPerWeek);
		milli = milli - (weeks * Utils.milliPerWeek);

		var days = Math.floor(milli / Utils.milliPerDay);
		milli = milli - (days * Utils.milliPerDay);

		var hours = Math.floor(milli / Utils.milliPerHour);
		milli = milli - (hours * Utils.milliPerHour);

		var minutes = Math.floor(milli / Utils.milliPerMinute);
		milli = milli - (minutes * Utils.milliPerMinute);

		var seconds = Math.floor(milli / 1000);
		milli = Math.floor(milli - (seconds * Utils.milliPerSecond));

		return {
			from_date: from_date,
			to_date: to_date,
			years: years,
			months: months,
			weeks: weeks,
			days: days,
			hours: hours,
			minutes: minutes,
			seconds: seconds,
			milli: milli,
			toString: function () {
				return `${years}y ${months}m ${weeks}w ${days}d ${hours.toString().padStart(2, "0")}:${minutes.toString().padStart(2, "0")}:${seconds.toString().padStart(2, "0")}.${milli.toString().padStart(3, "0")}`;
			}
		};
	};
};

console.log(Utils.dateDiff(new Date('1986-03-27'), new Date()).toString());
console.log(Utils.timeDiff(new Date('1986-03-27'), new Date()).toString());

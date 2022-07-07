package com.harrislogic.utilities;

import java.util.Calendar;
import java.util.Collection;
import java.util.Date;

public final class RandomUtls {
	static double randomDouble(double min, double max){
		if (max >= min){ return (Math.random() * (max - min + 1.0) + min); }
		else { return (Math.random() * (min - max + 1.0) + max); }
	}

	static double randomDouble(float min, float max){
		if (max >= min){ return (Math.random() * (max - min + 1.0) + min); }
		else { return (Math.random() * (min - max + 1.0) + max); }
	}

	static double randomDouble(int min, int max){
		if (max >= min){ return (Math.random() * (max - min + 1.0) + min); }
		else { return (Math.random() * (min - max + 1.0) + max); }
	}

	static double randomDouble(long min, long max){
		if (max >= min){ return (Math.random() * (max - min + 1.0) + min); }
		else { return (Math.random() * (min - max + 1.0) + max); }
	}

	static float randomFloat(float min, float max){
		return (float)(randomDouble(min, max));
	}

	static int randomInt(int min, int max){
		return (int)(randomDouble(min, max));
	}

	static long randomLong(long min, long max){
		return (long)(randomDouble(min, max));
	}

	static Character getRandom(String string){
		return string != null && string.length() > 0 ? string.charAt(randomInt(0, string.length() - 1)) : null;
	}

	static Object getRandom(Collection<Object> array){
		return getRandom(array.toArray());
	}

	static Object getRandom(Object[] array){
		return array != null && array.length > 0 ? array[randomInt(0, array.length - 1)] : null;
	}

	static Date getRandomDateBetween(Date start, Date end){
		return getRandomDateBetween(start, end, false);
	}

	static Date getRandomDateBetween(Date start, Date end, Boolean withTime){
		long timeInMillis = randomLong(start.getTime(), end.getTime());
		Calendar date = Calendar.getInstance();
		date.setTimeInMillis(timeInMillis);
		if (!withTime){
			date.set(Calendar.HOUR_OF_DAY, 0);
			date.set(Calendar.MINUTE, 0);
			date.set(Calendar.SECOND, 0);
			date.set(Calendar.MILLISECOND, 0);
		}
		return date.getTime();
	}

	static String randomAlphanumeric(String pattern){
		String letters = "ABCDEFGHJKLMNPQRSTUVWXYZ";
		String consonants = "BCDFGHJKLMNPQRSTVWXYZ";
		String vowels = "AEIOU";
		String hex = "0123456789ABCDEF";

		StringBuilder builder = new StringBuilder();
		for (int i = 0; i < pattern.length(); i++){
			switch(pattern.charAt(i)){
				case 'X': builder.append(randomInt(1, 9));
					break;
				case 'x': builder.append(randomInt(0, 9));
					break;
				case 'L': builder.append(getRandom(letters));
					break;
				case 'l': builder.append(getRandom(letters).toString().toLowerCase());
					break;
				case 'A':
					if (Math.random() < 0.5){ builder.append(getRandom(letters)); }
					else { builder.append(getRandom(letters).toString().toLowerCase()); }
					break;
				case 'C': builder.append(getRandom(consonants));
					break;
				case 'c': builder.append(getRandom(consonants).toString().toLowerCase());
					break;
				case 'E':
					if (Math.random() < 0.5){ builder.append(getRandom(consonants)); }
					else { builder.append(getRandom(consonants).toString().toLowerCase()); }
					break;
				case 'V': builder.append(getRandom(vowels));
					break;
				case 'v': builder.append(getRandom(vowels).toString().toLowerCase());
					break;
				case 'F':
					if (Math.random() < 0.5){ builder.append(getRandom(vowels)); }
					else { builder.append(getRandom(vowels).toString().toLowerCase()); }
					break;
				case 'B': builder.append(randomInt(0, 1));
					break;
				case 'O': builder.append(randomInt(0, 7));
					break;
				case 'H': builder.append(getRandom(hex));
					break;
				default: builder.append(pattern.charAt(i));
			}
		}
		return builder.toString();
	}
}

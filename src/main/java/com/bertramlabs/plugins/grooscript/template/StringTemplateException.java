package com.bertramlabs.plugins.grooscript.template;

/**
* When a String Template Lexical parser error is reached this exception is thrown.
* @author David Estes
*/
public class StringTemplateException extends Exception {
	public StringTemplateException(String message) {
        super(message);
    }
}
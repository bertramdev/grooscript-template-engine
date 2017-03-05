package com.bertramlabs.plugins.grooscript.template.symbols


public interface Symbol {

	Integer getLine();
	Integer getColumn();
	Integer getPosition();
	Integer getLength();
	void setLength(Integer length);
	String getValue();
	void setValue(String value);
}

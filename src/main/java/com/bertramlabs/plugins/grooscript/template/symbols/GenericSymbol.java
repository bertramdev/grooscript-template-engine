package com.bertramlabs.plugins.grooscript.template.symbols;

import java.util.List;
import java.util.ArrayList;

public class GenericSymbol implements Symbol {
	private Integer line;
	private Integer column;
	private Integer position;
	private Integer length;
	private String value;

	public void setValue(String value) {
		this.value = value;
	}

	public String getValue() {
		return value;
	}


	public Integer getLine() {
		return line;
	}

	public Integer getLength() {
		return length;
	}

	public void setLength(Integer length) {
		this.length = length;
	}

	public Integer getColumn() {
		return column;
	}

	public Integer getPosition() {
		return position;
	}

	public GenericSymbol() {
	}

	public GenericSymbol(String value,Integer line, Integer column,Integer position) {
		this.value = value;
		this.line = line;
		this.column = column;
		this.position = position;
	}
}

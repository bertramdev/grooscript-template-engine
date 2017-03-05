package com.bertramlabs.plugins.grooscript.template

import com.bertramlabs.plugins.grooscript.template.symbols.Symbol;
import org.grooscript.GrooScript

public class GrooscriptTemplateEngine {
	

	public GrooscriptTemplate createTemplate(String contents) {

		String prefixJs = """
var templateString = "";


"""

		String parsedContents = prefixJs

		ArrayList<Symbol> elements = new ArrayList<Symbol>()
		StringReader reader = new StringReader(contents)
		StringTemplateLexer lexer = new StringTemplateLexer(reader)
		try {
			while((element = lexer.yylex()) != null) {
				elements << element
			}
			int lastPosition = 0

			elements.each { currElement ->

				String templateString =  input.substring(lastPosition,currElement.getPosition())
				def lines = templateString.split("\n")
				lines.eachWithIndex { line, index ->
					parsedContents += "templateString = templateString + \"${line.replace('"','\\"')}${index == lines.size()-1 ? '' : '\n'}\""
				}
				lastPosition = currElement.getPosition() + currElement.getLength()

				parsedContents += renderElement(currElement)
			}
			if(lastPosition < input.size()) {
				String templateString =  input.substring(lastPosition,input.size())

				def lines = templateString.split("\n")
				lines.eachWithIndex { line, index ->
					parsedContents += "templateString = templateString + \"${line.replace('"','\\"')}${index == lines.size()-1 ? '' : '\n'}\""
				}
			}
		} catch(StringTemplateException ex) {
			throw new StringTemplateException("Error Parsing Grooscript Template ${ex.getMessage()} State: ${lexer.yystate()}")
		}

		parsedContents += "" +
			""

		return new GrooscriptTemplate(GrooScript.convert(parsedContents));
	}

	protected String renderElement(Symbol sym) {
		"""
templateString = templateString + (function() {return ${sym.value})();
"""
	}
}
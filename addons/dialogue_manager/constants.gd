class_name DMConstants extends RefCounted


const USER_CONFIG_PATH = "user://dialogue_manager_user_config.json"
const CACHE_PATH = "user://dialogue_manager_cache.json"


enum MutationBehaviour {
	Wait,
	DoNotWait,
	Skip
}

enum TranslationSource {
	None,
	Guess,
	CSV,
	PO
}

# Token types

const TOKEN_FUNCTION = &"function"
const TOKEN_DICTIONARY_REFERENCE = &"dictionary_reference"
const TOKEN_DICTIONARY_NESTED_REFERENCE = &"dictionary_nested_reference"
const TOKEN_GROUP = &"group"
const TOKEN_ARRAY = &"array"
const TOKEN_DICTIONARY = &"dictionary"
const TOKEN_PARENS_OPEN = &"parens_open"
const TOKEN_PARENS_CLOSE = &"parens_close"
const TOKEN_BRACKET_OPEN = &"bracket_open"
const TOKEN_BRACKET_CLOSE = &"bracket_close"
const TOKEN_BRACE_OPEN = &"brace_open"
const TOKEN_BRACE_CLOSE = &"brace_close"
const TOKEN_COLON = &"colon"
const TOKEN_COMPARISON = &"comparison"
const TOKEN_ASSIGNMENT = &"assignment"
const TOKEN_OPERATOR = &"operator"
const TOKEN_COMMA = &"comma"
const TOKEN_NULL_COALESCE = &"null_coalesce"
const TOKEN_DOT = &"dot"
const TOKEN_CONDITION = &"condition"
const TOKEN_BOOL = &"bool"
const TOKEN_NOT = &"not"
const TOKEN_AND_OR = &"and_or"
const TOKEN_STRING = &"string"
const TOKEN_NUMBER = &"number"
const TOKEN_VARIABLE = &"variable"
const TOKEN_COMMENT = &"comment"

const TOKEN_VALUE = &"value"
const TOKEN_ERROR = &"error"

# Line types

const TYPE_UNKNOWN = &""
const TYPE_IMPORT = &"import"
const TYPE_USING = &"using"
const TYPE_COMMENT = &"comment"
const TYPE_RESPONSE = &"response"
const TYPE_TITLE = &"title"
const TYPE_CONDITION = &"condition"
const TYPE_WHILE = &"while"
const TYPE_MATCH = &"match"
const TYPE_WHEN = &"when"
const TYPE_MUTATION = &"mutation"
const TYPE_GOTO = &"goto"
const TYPE_DIALOGUE = &"dialogue"
const TYPE_RANDOM = &"random"
const TYPE_ERROR = &"error"

# Line IDs

const ID_NULL = &""
const ID_ERROR = &"error"
const ID_ERROR_INVALID_TITLE = &"invalid title"
const ID_ERROR_TITLE_HAS_NO_BODY = &"title has no body"
const ID_END = &"end"
const ID_END_CONVERSATION = &"end!"

# Errors

const ERR_ERRORS_IN_IMPORTED_FILE = 100
const ERR_FILE_ALREADY_IMPORTED = 101
const ERR_DUPLICATE_IMPORT_NAME = 102
const ERR_EMPTY_TITLE = 103
const ERR_DUPLICATE_TITLE = 104
const ERR_TITLE_INVALID_CHARACTERS = 106
const ERR_UNKNOWN_TITLE = 107
const ERR_INVALID_TITLE_REFERENCE = 108
const ERR_TITLE_REFERENCE_HAS_NO_CONTENT = 109
const ERR_INVALID_EXPRESSION = 110
const ERR_UNEXPECTED_CONDITION = 111
const ERR_DUPLICATE_ID = 112
const ERR_MISSING_ID = 113
const ERR_INVALID_INDENTATION = 114
const ERR_INVALID_CONDITION_INDENTATION = 115
const ERR_INCOMPLETE_EXPRESSION = 116
const ERR_INVALID_EXPRESSION_FOR_VALUE = 117
const ERR_UNKNOWN_LINE_SYNTAX = 118
const ERR_TITLE_BEGINS_WITH_NUMBER = 119
const ERR_UNEXPECTED_END_OF_EXPRESSION = 120
const ERR_UNEXPECTED_FUNCTION = 121
const ERR_UNEXPECTED_BRACKET = 122
const ERR_UNEXPECTED_CLOSING_BRACKET = 123
const ERR_MISSING_CLOSING_BRACKET = 124
const ERR_UNEXPECTED_OPERATOR = 125
const ERR_UNEXPECTED_COMMA = 126
const ERR_UNEXPECTED_COLON = 127
const ERR_UNEXPECTED_DOT = 128
const ERR_UNEXPECTED_BOOLEAN = 129
const ERR_UNEXPECTED_STRING = 130
const ERR_UNEXPECTED_NUMBER = 131
const ERR_UNEXPECTED_VARIABLE = 132
const ERR_INVALID_INDEX = 133
const ERR_UNEXPECTED_ASSIGNMENT = 134
const ERR_UNKNOWN_USING = 135
const ERR_EXPECTED_WHEN_OR_ELSE = 136
const ERR_ONLY_ONE_ELSE_ALLOWED = 137
const ERR_WHEN_MUST_BELONG_TO_MATCH = 138
const ERR_CONCURRENT_LINE_WITHOUT_ORIGIN = 139
const ERR_GOTO_NOT_ALLOWED_ON_CONCURRECT_LINES = 140
const ERR_UNEXPECTED_SYNTAX_ON_NESTED_DIALOGUE_LINE = 141
const ERR_NESTED_DIALOGUE_INVALID_JUMP = 142


static var _current_locale: String = ""
static var _current_translation: Translation


## Get the error message
static func get_error_message(error: int) -> String:
	match error:
		ERR_ERRORS_IN_IMPORTED_FILE:
			return translate(&"errors.import_errors")
		ERR_FILE_ALREADY_IMPORTED:
			return translate(&"errors.already_imported")
		ERR_DUPLICATE_IMPORT_NAME:
			return translate(&"errors.duplicate_import")
		ERR_EMPTY_TITLE:
			return translate(&"errors.empty_title")
		ERR_DUPLICATE_TITLE:
			return translate(&"errors.duplicate_title")
		ERR_TITLE_INVALID_CHARACTERS:
			return translate(&"errors.invalid_title_string")
		ERR_TITLE_BEGINS_WITH_NUMBER:
			return translate(&"errors.invalid_title_number")
		ERR_UNKNOWN_TITLE:
			return translate(&"errors.unknown_title")
		ERR_INVALID_TITLE_REFERENCE:
			return translate(&"errors.jump_to_invalid_title")
		ERR_TITLE_REFERENCE_HAS_NO_CONTENT:
			return translate(&"errors.title_has_no_content")
		ERR_INVALID_EXPRESSION:
			return translate(&"errors.invalid_expression")
		ERR_UNEXPECTED_CONDITION:
			return translate(&"errors.unexpected_condition")
		ERR_DUPLICATE_ID:
			return translate(&"errors.duplicate_id")
		ERR_MISSING_ID:
			return translate(&"errors.missing_id")
		ERR_INVALID_INDENTATION:
			return translate(&"errors.invalid_indentation")
		ERR_INVALID_CONDITION_INDENTATION:
			return translate(&"errors.condition_has_no_content")
		ERR_INCOMPLETE_EXPRESSION:
			return translate(&"errors.incomplete_expression")
		ERR_INVALID_EXPRESSION_FOR_VALUE:
			return translate(&"errors.invalid_expression_for_value")
		ERR_FILE_NOT_FOUND:
			return translate(&"errors.file_not_found")
		ERR_UNEXPECTED_END_OF_EXPRESSION:
			return translate(&"errors.unexpected_end_of_expression")
		ERR_UNEXPECTED_FUNCTION:
			return translate(&"errors.unexpected_function")
		ERR_UNEXPECTED_BRACKET:
			return translate(&"errors.unexpected_bracket")
		ERR_UNEXPECTED_CLOSING_BRACKET:
			return translate(&"errors.unexpected_closing_bracket")
		ERR_MISSING_CLOSING_BRACKET:
			return translate(&"errors.missing_closing_bracket")
		ERR_UNEXPECTED_OPERATOR:
			return translate(&"errors.unexpected_operator")
		ERR_UNEXPECTED_COMMA:
			return translate(&"errors.unexpected_comma")
		ERR_UNEXPECTED_COLON:
			return translate(&"errors.unexpected_colon")
		ERR_UNEXPECTED_DOT:
			return translate(&"errors.unexpected_dot")
		ERR_UNEXPECTED_BOOLEAN:
			return translate(&"errors.unexpected_boolean")
		ERR_UNEXPECTED_STRING:
			return translate(&"errors.unexpected_string")
		ERR_UNEXPECTED_NUMBER:
			return translate(&"errors.unexpected_number")
		ERR_UNEXPECTED_VARIABLE:
			return translate(&"errors.unexpected_variable")
		ERR_INVALID_INDEX:
			return translate(&"errors.invalid_index")
		ERR_UNEXPECTED_ASSIGNMENT:
			return translate(&"errors.unexpected_assignment")
		ERR_UNKNOWN_USING:
			return translate(&"errors.unknown_using")
		ERR_EXPECTED_WHEN_OR_ELSE:
			return translate(&"errors.expected_when_or_else")
		ERR_ONLY_ONE_ELSE_ALLOWED:
			return translate(&"errors.only_one_else_allowed")
		ERR_WHEN_MUST_BELONG_TO_MATCH:
			return translate(&"errors.when_must_belong_to_match")
		ERR_CONCURRENT_LINE_WITHOUT_ORIGIN:
			return translate(&"errors.concurrent_line_without_origin")
		ERR_GOTO_NOT_ALLOWED_ON_CONCURRECT_LINES:
			return translate(&"errors.goto_not_allowed_on_concurrect_lines")
		ERR_UNEXPECTED_SYNTAX_ON_NESTED_DIALOGUE_LINE:
			return translate(&"errors.unexpected_syntax_on_nested_dialogue_line")
		ERR_NESTED_DIALOGUE_INVALID_JUMP:
			return translate(&"errors.err_nested_dialogue_invalid_jump")

	return translate(&"errors.unknown")


static func translate(string: String) -> String:
	var locale: String = TranslationServer.get_tool_locale()
	if _current_translation == null or _current_locale != locale:
		var base_path: String = new().get_script().resource_path.get_base_dir()
		var translation_path: String = "%s/l10n/%s.po" % [base_path, locale]
		var fallback_translation_path: String = "%s/l10n/%s.po" % [base_path, locale.substr(0, 2)]
		var en_translation_path: String = "%s/l10n/en.po" % base_path
		_current_translation = load(translation_path if FileAccess.file_exists(translation_path) else (fallback_translation_path if FileAccess.file_exists(fallback_translation_path) else en_translation_path))
		_current_locale = locale
	return _current_translation.get_message(string)

%{
	#include <cstdio>
	#include <cstdlib>
	#include <cstring>

	#include <iostream>
	#include <string>
	#include <vector>

	using namespace std;

	int yylex(void);
	void yyerror(const char *);
%}

/* DEFINITION OF CLASS SYMBOL */
%{
	/* This class represents the elements that are used in the compiler. 
	 * Those factors can quote variables. Making variables of type symbol 
	 * has become a much better control of these elements as well as the 
	 * ability to store values ​​associated with them and their types. */
	class Symbol
	{
		private:
			string symbol_name;
			string symbol_type;
			string symbol_value;
	
		public:
			Symbol( string name )
			{
				this->set_symbol_name( name );
			}

			Symbol( string name, string type )
			{
				this->set_symbol_name( name );
				this->set_symbol_type( type );
			}

			Symbol( string name, string type, string value )
			{
				this->set_symbol_name( name );
				this->set_symbol_type( type );
				this->set_symbol_value( value );
			}

			string get_symbol_name()
			{
				return this->symbol_name;
			}

			string get_symbol_type( )
			{
				return this->symbol_type;
			}

			string get_symbol_value( )
			{
				return this->symbol_value;
			}

			void set_symbol_name( string name )
			{
				this->symbol_name = name;
			}

			void set_symbol_type( string type )
			{
				this->symbol_type = type;
			}

			void set_symbol_value( string value )
			{
				this->symbol_value = value;
			}

			void list_attributes_symbol( )
			{
				const string name = this->get_symbol_name();
				const string type = this->get_symbol_type();
				const string value = this->get_symbol_value();
	
				cout << "Nome: "  << name  << endl
					  << "Tipo: "  << type  << endl
					  << "Valor: " << value << endl;
			}
	};
%}

/* DEFINITION OF CLASS SYMBOL_TABLE */
%{
	/* This class is the symbol table that are part of the lexical and 
	 * syntactic part of the compiler. Through it the specific functions in 
	 * this class are several possible actions, including the insertion and 
	 * search symbols quickly and easily. */
	class SymbolTable
	{
		private:
			vector<Symbol> table;
	
		public:
			/* Empty constructor of SymbolTable. */
			SymbolTable( )
			{
				// Nothing To Do
			}

			/* This function provides the action to insert, in symbol table, 
			 * new symbols that can be used later in the compiler. */
			void insert_symbol( const Symbol inserted_symbol )
			{
					this->table.push_back( inserted_symbol );
			}

			/* This function provides the action of deleting symbols of the 
			 * symbol table. */
			void delete_symbol( Symbol deleted_symbol )
			{	
				const unsigned int length_table = this->table.size();
	
				for( unsigned int i = 0; i < length_table; i++ )
				{
					const string tested_name   = table[ i ].get_symbol_name();
					const string searched_name = deleted_symbol.get_symbol_name();
		
					if( tested_name == searched_name )
					{	
						this->table.erase( table.begin() + ( i - 1 ) );
			
					} else
					{
						// Nothing To Do
					}
				}
			}

			/* This function provides the action to delet all symbols in symbol
			 * table. */
			void delete_all_symbols( )
			{
				this->table.clear( );
			}

			/* This function provides the action to seek a symbol inserted in symbol
			 * table. */
			Symbol find_symbol_by_name( const string searched_name )
			{
				Symbol found_symbol("not valid");
	
				const unsigned int length_table = this->table.size();
	
				for( unsigned int i = 0; i < length_table; i++ )
				{
					string tested_name = table[ i ].get_symbol_name();
		
					if( tested_name == searched_name )
					{		
						found_symbol = table[ i ];
			
					} else
					{
						// Nothing To Do
					}
				}
	
				return found_symbol;
			}

			/* Provides the actual size of the symbol table. */
			int size_table( )
			{
				const int size_of_table = this->table.size();
				return size_of_table;
			}

			vector<Symbol> get_table( )
			{
				return this->table;
			}

			/* This function provides the ability to list all elements contained 
			 * in the table. */
			void list_table_elements( )
			{
				vector<Symbol> listed_table = this->table;
				const unsigned int length_table = this->table.size();
	
				for( unsigned int i = 0; i < length_table; i++ )
				{
					string name_element = table[ i ].get_symbol_name();
		
					cout << i << ". " << name_element << endl;
				}
	
				cout << endl;
			}
	};
%}

%{
	SymbolTable table;
%}

%union{
	int   integer;
	float real;
	char *text;
}

%token<text> COLON
%token<text> VARIABLE

%token<text> STRING
%token<text> INT
%token<text> FLOAT

%token TYPE_STRING
%token TYPE_INT
%token TYPE_CHAR
%token TYPE_FLOAT
%token TYPE_BOOLEAN

%token PRINTF
%token SCANF

%token ATTRIBUTION

%token NEWLINE
%token START
%token END

%start program

%%

program:
	/* Regra Vazia */
	| program content_program
	;

content_program:
	NEWLINE { printf("\n"); }
	| begin_of_program
	| end_of_program
	| declaration
	| attribution
	| output
	| input
	;

Type:
	TYPE_INT {
		char Int[] = "int";
		$<text>$ = Int;

	} | TYPE_FLOAT {
		char Float[] = "float";
		$<text>$ = Float;

	} | TYPE_CHAR {
		char Char[] = "char";
		$<text>$ = Char;

	} | TYPE_STRING {
		char String[] = "char *";
		$<text>$ = String;

	};

number:
	INT {
		$<text>$ = $1;

	} | FLOAT {
		$<text>$ = $1;

	};

text:
	STRING {
		$<text>$ = $1;
	};

value:
	VARIABLE {
	} | number
	| text
	;

begin_of_program:
	START {

		cout << "#include <stdio.h>"  << endl
			  << "#include <stdlib.h>" << endl
			  << "#include <string.h>" << endl
			  << "#include <math.h>"   << endl
			  << endl;

		cout << "int main(int argc, char *argv[])" << endl
			  << "{";

	};

end_of_program:
	END {
		cout << "}" << endl;

	};

declaration:
	VARIABLE COLON Type {
		Symbol variable( $<text>1, $<text>3 );
		
		table.insert_symbol( variable );
		
		cout << variable.get_symbol_type() << " "
			  << variable.get_symbol_name() << ";";
	};

attribution:
	VARIABLE ATTRIBUTION value {
		string equal = " = ";
		string semi_colon = ";";

		string built_string = "";

		built_string.append( $<text>1 );
		built_string.append( equal );
		built_string.append( $<text>3 );
		built_string.append( semi_colon );

		cout << built_string;

		strcpy( $<text>$, built_string.c_str() );
	};

output:
	 PRINTF text {
		string begin_printf = "printf(";
		string end_printf   = ");";
		
		string built_string = "";
		
		built_string.append( begin_printf );
		built_string.append( $<text>2 );
		built_string.append( end_printf );
		
		cout << built_string << endl;

		strcpy( $<text>$, built_string.c_str() );
	};

input:
	SCANF VARIABLE {
		string begin_scanf = "scanf(";
		string end_scanf     = ");";
		
		string built_string = "";
		
		built_string.append( begin_scanf );
		built_string.append( $<text>2 );
		built_string.append( end_scanf );
		
		/* TODO: Deve-se capturar o tipo da variável para definir o tipo de leitura mais adequada.
				   Proponho utilizar uma struct com dois elementos para definir uma VARIABLE. */
		cout << built_string << endl;

		strcpy( $<text>$, built_string.c_str() );
	};

%%

int main(void) {
   yyparse();
}

	void yyerror (char const *s) {
   	printf ("%s\n", s);
	}

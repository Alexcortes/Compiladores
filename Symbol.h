#include <iostream>
#include <string>

using namespace std;

class Symbol
{
	private:
		string symbol_name = "";
	
	public:
		Symbol( string );

		string get_name( );

		void set_name( string );
};

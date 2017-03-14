#include <ff++.hpp>

using namespace Fem2D;

bool doesMatch(string* toMatch)
{
    ifstream input; input.open("parameters.txt");
    string line = " ";

    string variableName = "";
    double variableValue = 0;
    string dummy = "";

    while(input >> variableName >> dummy >> variableValue)
    {
        if (variableName == *toMatch)
        {
            return true;
        }
    }
    return false;
}

double getMatch(string* toMatch)
{
    ifstream input; input.open("parameters.txt");
    string line = " ";

    string variableName = "";
    double variableValue = 0;
    string dummy = "";

    while(input >> variableName >> dummy >> variableValue)
    {
        if (variableName == *toMatch)
        {
            return variableValue;
        }
    }
}

void init(){
    Global.Add("doesMatch","(",new OneOperator1<bool,string*>(doesMatch));
    Global.Add("getMatch","(",new OneOperator1<double,string*>(getMatch));
}

LOADFUNC(init);

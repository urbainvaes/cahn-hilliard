func bool doesMatch(string filename, string match) {
    ifstream file(filename);
    string s;
    for (getline(file,s); s.length != 0; getline(file,s)) {
        if (s.find(match) != -1) {
            return true;
        }
    }
    return false;
}

func real getMatch(string filename, string match) {
    ifstream file(filename);
    string s;
    for (getline(file,s); s.length != 0; getline(file,s)) {
        if (s.find(match) != -1) {
            return atof(s(s.find("=")+2:s.length));
        }
    }
}

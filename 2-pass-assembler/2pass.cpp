#include <bits/stdc++.h>
using namespace std;

struct mnemonics{
	string name;
	string mnemonic;
	int size;
}mot[13];

class Symbol{
    public:
        string label, addr;

        Symbol(string label) {
            this->label = label;
            addr = "";
        }

        Symbol(string label, string addr) {
            this->label = label;
            this->addr = addr;
        }
};



void init() {
    mot[0] = {"ORG", "16", 3};
    mot[1] = {"LDA", "3A", 3};
    mot[2] = {"STA", "32", 3};
    mot[3] = {"LXI", "21", 3};
    mot[4] = {"MOVA,M", "7E", 1};
    mot[5] = {"MOVB,A", "47", 1};
    mot[6] = {"MVIA", "3E", 2};
    mot[7] = {"MVIC", "43", 2};
    mot[8] = {"CMPB", "B8", 1};
    mot[9] = {"DCRC", "0D", 1};
    mot[10] = {"JNZ", "C2", 3};
    mot[11] = {"INXH", "23", 1};
    mot[12] = {"HLT", "76", 1};

    /*
     * ORG 16
     * LDA -> 3A
     * STA -> 32
     * LXI H -> 21
     * MOV A, M -> 7E
     * MOV B, M -> 46
     * MOV C, M -> 4E
     * MOV B, A -> 47
     * MVI A -> 3E
     * CMP B -> B8
     * DCR C -> 0D
     * JNZ -> C2
     * INX H ->23
     * HLT -> 76
     */
}

ifstream infile;
string word;
vector<Symbol*> symtable;

string toHex(int num) {
    string hex = "";

    while(num) {
        int x = num % 16;
        hex += x + (x < 10 ? 48 : 55);
        num /= 16;
    }

    reverse(hex.begin(), hex.end());
    return hex;
}

int toDecimal(string hex) {
    int base = 1, dec = 0, len = hex.size();

    for(int i=len-1; i>=0; i--) {
        int x = 55;
        if(hex[i] >= '0' && hex[i] <= '9') 
            x = 48;

        dec += (hex[i]-x) * base;
        base *= 16;
    }

    return dec;
}


int search_mot(string opcode) {
    for(int i=0; i<13; i++)
        if(mot[i].name == opcode)
            return i;
    return -1;
}

int search_table(string word) {
    int idx = 0;

    for(auto& it: symtable) {
        if(it->label == word)
            return idx;
        idx++;
    }

    return -1;
}

void insertSymbol(string word) {
    int idx = search_table(word);
    if(idx == -1)
        symtable.push_back(new Symbol(word));
}

void insertSymbol(string word, string addr) {
    int idx = search_table(word);
    if(idx == -1)
        symtable.push_back(new Symbol(word, addr));
    else if(symtable[idx]->addr.empty())
        symtable[idx]->addr = addr;
}

string extract(string opcode) {
    infile >> word;
    if(opcode == "ORG" || opcode == "LDA" || 
            opcode == "STA" || opcode == "LXI")
        return opcode;

    if(opcode == "MVI"){
        for(char c: word) {
            if(c == ',')
                break;
            opcode += c;
        }
    }

    else
        opcode += word;

    return opcode;
}

vector<string> extract2(string opcode) {
    infile >> word;
    string operand="";
    if(opcode == "ORG" || opcode == "LDA" || 
            opcode == "STA" || opcode == "LXI")
        return {opcode, word};

    if(opcode == "MVI"){
        for(char c: word) {
            if(c == ',')
                break;
            opcode += c;
        }

        for(char c:word) {
            operand += c;
            if(c == ',')
                operand = "";
        }
    }

    else
        opcode += word;

    return {opcode ,operand};
}

void printhexaddr(string hex) {
    int len = hex.size(), cnt=0;
    string temp = "";
    for(int i=len-1; i>=0; i--) {
        temp = hex[i] + temp;

        ++cnt;
        if(cnt<=len && cnt % 2 == 0)
            cout<<temp + "H ", temp = "";
    }
}

void printTable() {
    cout<<endl<<"-----Symbol Table-----"<<endl;

    cout<<"Label"<<"\t\t"<<"Address"<<endl;
    for(auto it: symtable) {
        cout<<it->label<<"\t\t"<<it->addr<<endl;
    }

    cout<<"-------------------------"<<endl;
}
void pass1() {
    cout<<"Scanning for Pass1......."<<endl;

    infile.open("input.txt");
    int base, cnt=0;

    while(infile >> word) {
        string opcode = word;

        if((int)word.find(":") != -1) {
            // label
            word.pop_back();
            insertSymbol(word, toHex(base+cnt));
        }

        else {
            // instruction
            if(word == "ORG") {
                infile >> word;
                base = toDecimal(word);
                insertSymbol("START", word);
                continue;
            }

            else if(word == "JNZ") {
                infile >> word;
                insertSymbol(word);
            }
            else if(word != "HLT")
                opcode = extract(word);
        }


        int idx = search_mot(opcode);
        if(idx != -1)
            cnt += mot[idx].size;

        // cout<<opcode<<" "<<idx<<endl;

    }

    cout<<"Generating Symbol Table......."<<endl;
    // for(auto it: symtable) cout<<it->label<<":"<<it->addr<<endl;
    cout<<"-------First Pass Completed--------"<<endl;
    infile.close();
}

void pass2() {
    cout<<endl<<"------Pass2-------"<<endl;
    infile.open("input.txt");
    int idx;
    while(infile >> word) {
        if((int)word.find(":") != -1) {
            word.pop_back();
            idx = search_table(word);
            // printhexaddr(symtable[idx]->addr);
            cout<<symtable[idx]->addr<<": ";
        }

        else {
            string opcode = word, label="", operand="";
            if(word == "ORG") {
                infile >> word;
                continue;
            }
            
            if(word == "JNZ") {
                infile >> word;
                label = word;
                // idx = search_table(label);
            }

            else if(word != "HLT") {
                // opcode = extract(opcode);
                vector<string> v= extract2(opcode);
                opcode = v[0];
                operand = v[1];
            }


            int op = search_mot(opcode);
            
            cout<<mot[op].mnemonic<<" ";

            if(!label.empty()) {
                int x = search_table(label);
                printhexaddr(symtable[x]->addr);
            }

            if(!operand.empty())
                printhexaddr(operand);
            cout<<endl;
        }
    }


}


int main(){
    init();
    pass1();
    printTable();
    pass2();

}


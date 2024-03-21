/**
 * 本程序用于将 <code> <char> 格式的码表文件转换为 <code> <char> <freq> 格式的码表文件
 * 字码频次按原文件次序降序处理
*/

#include <iostream>
#include <cstring>
#include <fstream>
using namespace std;

/**
 * 用于判断文件两行的码值是否相同
 * 即查看第一个空格前的四个以内的字符是否相同
*/
bool equl(const char* a, const char* b) {
    for (int i = 0; i < 4; i++) {
        if (*(a + i) != *(b + i)) {
            return false;
        }
        else if (*(a + i) == ' ' || *(b + i) == ' ') {
            break;
        }
    }
    return true;
}

void handleFile(ifstream& read, ofstream& out) {
    int i = 100, option = 1;
    char* buffer_poll = new char[102];  // 分配一个内存池，存放当前行与前一行内容
    memset(buffer_poll, 0, 102);
    // 内存池对半分，由 option 控制二者转换
    char* prev_buffer = buffer_poll;
    char* buffer = buffer_poll + 50;
    prev_buffer[0] = ' ';
    while (!read.eof()) {
        buffer = buffer_poll + option * 50;
        read.getline(buffer, 50);
        if (equl(buffer, prev_buffer)) {
            i--;
        }
        else {
            i = 100;
        }
        // 在行尾附加伪频率
        if (strlen(buffer) != 0)
            out << buffer << " " << i << endl;

        prev_buffer = buffer;
        option = 1 - option;
    }
    delete[] buffer_poll;
}

int main(int argc, char **argv) {
    // 打开文件
    ifstream read("vimim.yuhao.txt");
    ofstream out("yuhao_origin.txt");
    if (read.is_open() && out.is_open()) {
        cout << "opened " << endl;

        handleFile(read, out);
        read.close();
        out.close();

        cout << "complete" << endl;
    }

    return 0;
}

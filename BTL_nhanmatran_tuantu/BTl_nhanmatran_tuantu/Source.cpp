#include <iostream>
#include <vector>
#include <chrono> // Thư viện để đo thời gian

using namespace std;

#define N 100 // Kích thước ma trận (N x N)

// Hàm nhân ma trận tuần tự
void matrixMultiplySequential(const vector<vector<float>>& A, const vector<vector<float>>& B, vector<vector<float>>& C, int width) {
    for (int i = 0; i < width; i++) {
        for (int j = 0; j < width; j++) {
            C[i][j] = 0; // Khởi tạo giá trị của C[i][j] là 0
            for (int k = 0; k < width; k++) {
                C[i][j] += A[i][k] * B[k][j];
            }
        }
    }
}

int main() {
    // Khởi tạo ma trận A, B và C
    vector<vector<float>> A(N, vector<float>(N, 1.0f)); // Ma trận A với tất cả phần tử là 1
    vector<vector<float>> B(N, vector<float>(N, 1.0f)); // Ma trận B với tất cả phần tử là 1
    vector<vector<float>> C(N, vector<float>(N, 0.0f)); // Ma trận C ban đầu chứa các giá trị 0

    // Đo thời gian thực hiện nhân ma trận tuần tự
    auto start = chrono::high_resolution_clock::now();
    matrixMultiplySequential(A, B, C, N);
    auto end = chrono::high_resolution_clock::now();

    cout << "N = " << N << endl;
    // Tính toán và in ra thời gian chạy
    chrono::duration<double, milli> elapsed = end - start;
    cout << "Thoi gian chay: " << elapsed.count() << " ms\n";

    return 0;
}

#include <iostream>
#include <cuda_runtime.h>

#define N 2000

using namespace std;

__global__ void matrixMultiplyKernel(int* A, int* B, int* C, int n) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    if (row < n && col < n) {
        int sum = 0;
        for (int k = 0; k < n; k++) {
            sum += A[row * n + k] * B[k * n + col];
        }
        C[row * n + col] = sum;
    }
}

int main() {
    
    int* A = new int[N * N];
    int* B = new int[N * N];
    int* C = new int[N * N];
    // Khởi tạo ma trận A và B gồm các phần tử đều là 1
    for (int i = 0; i < N * N; ++i) {
        A[i] = 1;
        B[i] = 1;
        C[i] = 0; // Khởi tạo ma trận C với 0
    }

    int* d_A, * d_B, * d_C;

    // Cấp phát bộ nhớ trên GPU
    cudaMalloc((void**)&d_A, N * N * sizeof(int));
    cudaMalloc((void**)&d_B, N * N * sizeof(int));
    cudaMalloc((void**)&d_C, N * N * sizeof(int));

    // Copy dữ liệu từ CPU sang GPU
    cudaMemcpy(d_A, A, N * N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, N * N * sizeof(int), cudaMemcpyHostToDevice);

    // Thiết lập kích thước lưới và block
    dim3 threadsPerBlock(16, 16);
    dim3 numBlocks((N + threadsPerBlock.x - 1) / threadsPerBlock.x, (N + threadsPerBlock.y - 1) / threadsPerBlock.y);

    // Khởi tạo các sự kiện để tính thời gian
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    // Bắt đầu tính thời gian
    cudaEventRecord(start);

    // Gọi kernel để thực hiện phép nhân
    matrixMultiplyKernel << <numBlocks, threadsPerBlock >> > (d_A, d_B, d_C, N);

    // Dừng tính thời gian
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    // Tính toán thời gian
    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);

    // Copy kết quả từ GPU về CPU
    cudaMemcpy(C, d_C, N * N * sizeof(int), cudaMemcpyDeviceToHost);

    // Thời gian chạy song song
    cout << "N = " << N << endl;
    cout << "Thoi gian chay: " << milliseconds << " ms" << endl;

    // Giải phóng bộ nhớ
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
    delete[] A;
    delete[] B;
    delete[] C;

    // Giải phóng các sự kiện
    cudaEventDestroy(start);
    cudaEventDestroy(stop);

    return 0;
}
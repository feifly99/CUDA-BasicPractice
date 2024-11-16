#include "CUDA_CAU_HEARER.h"

typedef unsigned int UINT;

__global__ void myCudaVectorAdd()
{

    return ;
}

__global__ void myCudaVectorMultiple()
{

    return;
}

__global__ void myCudaMatrixAdd()
{

    return;
}

__global__ void myCudaMatrixMultiple(
	float* data1,
	float* data2,
	size_t row1,
	size_t col1,
	size_t row2,
	size_t col2,
	float* ret
)
{
	UINT currRow = blockIdx.x * blockDim.x + threadIdx.x;
	UINT currCol = blockIdx.y * blockDim.y + threadIdx.y;
	float sum = 0.0;
	for (size_t j = 0; j < col1; j++)
	{
		sum += data1[currRow * col1 + j] * data2[j * col2 + currCol];
	}
	ret[currRow * col2 + currCol] = sum;	
	return;
}

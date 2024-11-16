#ifndef __CUDA_CALCULATE_HEAER__
#define __CUDA_CALCULATE_HEAER__

#include <stdio.h>
#include <Windows.h>
#include <stdlib.h>

#include "cuda_runtime.h"
#include "device_launch_parameters.h"

typedef enum _myCudaDataFlag
{
	CUDA_DATA_FLAG_$_VECTOR_$ = 1,
	CUDA_DATA_FLAG_$_MATRIX_$ = 2,
	CUDA_DATA_FLAG_$_TENSOR_$ = 3,
}myCudaDataFlag;

typedef struct _dataSet
{
	union _dataType
	{
		struct _vectorType
		{
			size_t size;
			float* vector;
			size_t objectReference;
		}V;

		struct _matrixType
		{
			size_t rowSize;
			size_t colSize;
			float** matrix;
			size_t objectReference;
		}M;

		struct _tensorType
		{
			size_t lenSize;
			size_t widSize;
			size_t higSize;
			float*** tensor;
			size_t objectReference;
		}T;

	}dataType;

	myCudaDataFlag dataFlag;

}DATA_SET, *PDATA_SET;

typedef enum _myCudaCalculateFlag
{
	CUDA_CAU_TYPE_$_ADD_$ = 1,
	CUDA_CAU_TYPE_$_MULTIPLE_$ = 2,
}myCudaCalculateFlag;

__global__ void myCudaVectorAdd();

__global__ void myCudaVectorMultiple();

__global__ void myCudaMatrixAdd();

__global__ void myCudaMatrixMultiple(
	float* data1, 
	float* data2,
	size_t row1,
	size_t col1,
	size_t row2,
	size_t col2,
	float* ret
);

#endif
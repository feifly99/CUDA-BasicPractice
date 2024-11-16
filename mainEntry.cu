#include "baseHeader.h"

int main()
{
	SIZE_T dimension1[MAX_DIMENSION_SIZE] = { 20480, 10240 };
	PDATA_SET dataSet1 = makeDataSet(CUDA_DATA_FLAG_$_MATRIX_$, GENERATE_ALL_ONE, &dimension1, NULL);
	SIZE_T dimension2[MAX_DIMENSION_SIZE] = { 10240, 20480 };
	PDATA_SET dataSet2 = makeDataSet(CUDA_DATA_FLAG_$_MATRIX_$, GENERATE_ALL_ONE, &dimension2, NULL);
	float* result = NULL;
	callCuda(dataSet1, dataSet2, CUDA_DATA_FLAG_$_MATRIX_$, CUDA_CAU_TYPE_$_MULTIPLE_$, &result);
	ExFreeMem((PVOID*)&result);
	ExFreeDataSet(&dataSet2);
	ExFreeDataSet(&dataSet1);
	return 0;
}
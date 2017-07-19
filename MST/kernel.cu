
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <thrust/sort.h>
#include <thrust/iterator/zip_iterator.h>
#include <iostream>
#include <thrust/copy.h>
#include <thrust/device_vector.h>
#include <vector>
#include <thrust/remove.h>
#include <stdio.h>
const int v = 4;
using thrust::device_vector;

typedef struct {
	int src, dest, weight;
}borderland;
borderland* vert;

struct bordersort
{
	__host__ __device__
	bool operator()(borderland a, borderland b) {
		if (a.src == b.src) {
			if (a.dest == b.dest)
				return a.weight < b.weight;
			return a.dest < b.dest;
		}
		return a.src < b.src;
	}
};

struct borderselect
{
	__host__ __device__
	void operator()(borderland bdr) {
		int src = bdr.src;
		int dst = bdr.dest;
		int wgt = bdr.weight;
		
	}
};

int main()
{
	std::vector<borderland> tmp;
	cudaMalloc((void**)&vert, sizeof(int) * v);
	tmp.push_back({ 0,1,10 });
	tmp.push_back({ 0,2,6 });
	tmp.push_back({ 0,2,10 });
	tmp.push_back({ 0,3,5 });
	tmp.push_back({ 2,3,4 });
	tmp.push_back({ 1,3,15 });
	device_vector<borderland> borders(tmp);
	thrust::sort(borders.begin(), borders.end(), bordersort());
	thrust::for_each(borders.begin(), borders.end(), borderselect());
	thrust::copy(borders.begin(), borders.end(), tmp.begin());
	for (auto i : tmp)
		std::cout << i.src << "\t" << i.dest << "\t" << i.weight << std::endl;
	return 0;
}

// Helper function for using CUDA to add vectors in parallel.

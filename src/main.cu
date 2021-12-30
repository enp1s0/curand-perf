#include <iostream>
#include <chrono>
#include <curand.h>

const std::size_t min_num_data = 1u << 10;
const std::size_t max_num_data = 1u << 30;

namespace {
std::string get_rng_name_str(
		const curandRngType_t rng_type
		) {
	switch (rng_type) {
#define CASE_RNG_TYPE(rng) case rng: return #rng
		CASE_RNG_TYPE(CURAND_RNG_PSEUDO_DEFAULT);
		CASE_RNG_TYPE(CURAND_RNG_PSEUDO_XORWOW);
		CASE_RNG_TYPE(CURAND_RNG_PSEUDO_MRG32K3A);
		CASE_RNG_TYPE(CURAND_RNG_PSEUDO_MTGP32);
		CASE_RNG_TYPE(CURAND_RNG_PSEUDO_MT19937);
		CASE_RNG_TYPE(CURAND_RNG_PSEUDO_PHILOX4_32_10);
		CASE_RNG_TYPE(CURAND_RNG_QUASI_DEFAULT);
		CASE_RNG_TYPE(CURAND_RNG_QUASI_SOBOL32);
		CASE_RNG_TYPE(CURAND_RNG_QUASI_SCRAMBLED_SOBOL32);
		default:
			return "Unknown";
	}
}
} // noname namespace

void measure_perf(
		const curandRngType_t rng_type
		) {
	curandGenerator_t curand_gen;
	curandCreateGenerator(&curand_gen, rng_type);
	curandSetPseudoRandomGeneratorSeed(curand_gen, 0);

	float* data_ptr;
	cudaMalloc(&data_ptr, sizeof(float) * max_num_data);

	for (auto num_data = min_num_data; num_data <= max_num_data; num_data <<= 1) {
		cudaDeviceSynchronize();
		const auto start_clock = std::chrono::system_clock::now();

		curandGenerateUniform(curand_gen, data_ptr, num_data);

		cudaDeviceSynchronize();
		const auto end_clock = std::chrono::system_clock::now();

		const auto elapsed_time = std::chrono::duration_cast<std::chrono::microseconds>(end_clock - start_clock).count() * 1e-6;

		std::printf("%s,%lu,%e\n",
				get_rng_name_str(rng_type).c_str(),
				num_data,
				elapsed_time
				);
	}
}

int main() {
		measure_perf(CURAND_RNG_PSEUDO_DEFAULT);
		measure_perf(CURAND_RNG_PSEUDO_XORWOW);
		measure_perf(CURAND_RNG_PSEUDO_MRG32K3A);
		measure_perf(CURAND_RNG_PSEUDO_MTGP32);
		measure_perf(CURAND_RNG_PSEUDO_MT19937);
		measure_perf(CURAND_RNG_PSEUDO_PHILOX4_32_10);
		measure_perf(CURAND_RNG_QUASI_DEFAULT);
		measure_perf(CURAND_RNG_QUASI_SOBOL32);
		measure_perf(CURAND_RNG_QUASI_SCRAMBLED_SOBOL32);
}

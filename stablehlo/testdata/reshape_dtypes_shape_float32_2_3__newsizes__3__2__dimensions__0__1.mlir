// RUN-DISABLED(#1278): stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<2x3xf32>
    %1 = call @expected() : () -> tensor<3x2xf32>
    %2 = stablehlo.reshape %0 : (tensor<2x3xf32>) -> tensor<3x2xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<3x2xf32>, tensor<3x2xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<2x3xf32> {
    %0 = stablehlo.constant dense<[[-1.82101429, -0.562906504, -0.37062332], [0.430398703, 0.632702291, -3.97978783]]> : tensor<2x3xf32>
    return %0 : tensor<2x3xf32>
  }
  func.func private @expected() -> tensor<3x2xf32> {
    %0 = stablehlo.constant dense<[[-1.82101429, -0.562906504], [-0.37062332, 0.430398703], [0.632702291, -3.97978783]]> : tensor<3x2xf32>
    return %0 : tensor<3x2xf32>
  }
}

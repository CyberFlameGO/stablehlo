// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<1x2xf32>, tensor<3x2xf32>)
    %1 = call @expected() : () -> tensor<3x2xi1>
    %2 = stablehlo.broadcast_in_dim %0#0, dims = [0, 1] : (tensor<1x2xf32>) -> tensor<3x2xf32>
    %3 = stablehlo.compare  LT, %2, %0#1,  FLOAT : (tensor<3x2xf32>, tensor<3x2xf32>) -> tensor<3x2xi1>
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<3x2xi1>, tensor<3x2xi1>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x2xf32>, tensor<3x2xf32>) {
    %0 = stablehlo.constant dense<[[1.02973759, 4.76132393]]> : tensor<1x2xf32>
    %1 = stablehlo.constant dense<[[-0.0460182168, 3.88165617], [-5.93830442, -0.283103734], [0.394684255, -6.21158838]]> : tensor<3x2xf32>
    return %0, %1 : tensor<1x2xf32>, tensor<3x2xf32>
  }
  func.func private @expected() -> tensor<3x2xi1> {
    %0 = stablehlo.constant dense<false> : tensor<3x2xi1>
    return %0 : tensor<3x2xi1>
  }
}

#pragma once

namespace MathFuncCpp
{
	public ref class MathFunc sealed
	{
	public:
		MathFunc();

		// Our method that returns a string
		double add(double a, double b);
		double subtract(double a, double b);
		double multiply(double a, double b);
		double divide(double a, double b);
	};
}

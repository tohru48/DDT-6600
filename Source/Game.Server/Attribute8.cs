using System;
using System.Runtime.CompilerServices;

internal class Attribute8 : Attribute
{
	[CompilerGenerated]
	private byte byte_0;

	[CompilerGenerated]
	public byte method_0()
	{
		return byte_0;
	}

	[CompilerGenerated]
	private void method_1(byte byte_1)
	{
		byte_0 = byte_1;
	}

	public Attribute8(byte byte_1)
	{
		method_1(byte_1);
	}
}

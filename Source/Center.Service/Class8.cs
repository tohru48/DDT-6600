using System;
using System.Reflection;
internal class Class8
{
	internal delegate void Delegate2(object o);
	internal static System.Reflection.Module module_0;
	internal static void V9vFmKNN1NtaY(int typemdt)
	{
		System.Type type = Class8.module_0.ResolveType(33554432 + typemdt);
		System.Reflection.FieldInfo[] fields = type.GetFields();
		for (int i = 0; i < fields.Length; i++)
		{
			System.Reflection.FieldInfo fieldInfo = fields[i];
			System.Reflection.MethodInfo method = (System.Reflection.MethodInfo)Class8.module_0.ResolveMethod(fieldInfo.MetadataToken + 100663296);
			fieldInfo.SetValue(null, (System.MulticastDelegate)System.Delegate.CreateDelegate(type, method));
		}
	}
	public Class8()
	{
		
		
	}
	static Class8()
	{
		
		Class8.module_0 = typeof(Class8).Assembly.ManifestModule;
	}
}

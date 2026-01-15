using System;
using System.Reflection;
internal class Class4
{
	internal delegate void Delegate1(object o);
	internal static System.Reflection.Module module_0;
	internal static void an8xQoWWjNexN(int typemdt)
	{
		System.Type type = Class4.module_0.ResolveType(33554432 + typemdt);
		System.Reflection.FieldInfo[] fields = type.GetFields();
		for (int i = 0; i < fields.Length; i++)
		{
			System.Reflection.FieldInfo fieldInfo = fields[i];
			System.Reflection.MethodInfo method = (System.Reflection.MethodInfo)Class4.module_0.ResolveMethod(fieldInfo.MetadataToken + 100663296);
			fieldInfo.SetValue(null, (System.MulticastDelegate)System.Delegate.CreateDelegate(type, method));
		}
	}
	public Class4()
	{
		
		
	}
	static Class4()
	{
		
		Class4.module_0 = typeof(Class4).Assembly.ManifestModule;
	}
}

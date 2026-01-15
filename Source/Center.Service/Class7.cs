using Game.Service.actions;
using System;
using System.Collections;
using System.IO;
using System.Threading;
internal class Class7
{
	private static System.Collections.ArrayList arrayList_0;
	[System.STAThread]
	private static void Main(string[] args)
	{
		System.AppDomain.CurrentDomain.SetupInformation.PrivateBinPath = "." + System.IO.Path.DirectorySeparatorChar + "lib";
		System.Threading.Thread.CurrentThread.Name = "MAIN";
		Class7.smethod_0();
		if (args.Length == 0)
		{
			args = new string[]
			{
				"--start"
			};
		}
		string string_;
		System.Collections.Hashtable parameters;
		try
		{
			Class7.smethod_4(args, out string_, out parameters);
		}
		catch (System.ArgumentException ex)
		{
			System.Console.WriteLine(ex.Message);
			return;
		}
		Interface0 @interface = Class7.smethod_3(string_);
		if (@interface != null)
		{
			@interface.OnAction(parameters);
			return;
		}
		Class7.smethod_2();
	}
	private static void smethod_0()
	{
		Class7.smethod_1(new ConsoleStart());
	}
	private static void smethod_1(Interface0 interface0_0)
	{
		if (interface0_0 == null)
		{
			throw new System.ArgumentException("Action can't be bull", "actioni");
		}
		Class7.arrayList_0.Add(interface0_0);
	}
	public static void smethod_2()
	{
		System.Console.WriteLine("Syntax: RoadServer.exe {action} [param1=value1] [param2=value2] ...");
		System.Console.WriteLine("Possible actions:");
		foreach (Interface0 @interface in Class7.arrayList_0)
		{
			if (@interface.Syntax != null && @interface.Description != null)
			{
				System.Console.WriteLine(string.Format("{0,-20}\t{1}", @interface.Syntax, @interface.Description));
			}
		}
	}
	private static Interface0 smethod_3(string string_0)
	{
		foreach (Interface0 @interface in Class7.arrayList_0)
		{
			if (@interface.Name.Equals(string_0))
			{
				return @interface;
			}
		}
		return null;
	}
	private static void smethod_4(string[] string_0, out string string_1, out System.Collections.Hashtable hashtable_0)
	{
		hashtable_0 = new System.Collections.Hashtable();
		string_1 = null;
		if (!string_0[0].StartsWith("--"))
		{
			throw new System.ArgumentException("First argument must be the action");
		}
		string_1 = string_0[0];
		if (string_0.Length == 1)
		{
			return;
		}
		for (int i = 1; i < string_0.Length; i++)
		{
			string text = string_0[i];
			if (text.StartsWith("--"))
			{
				throw new System.ArgumentException("At least two actions given and only one action allowed!");
			}
			if (text.StartsWith("-"))
			{
				int num = text.IndexOf('=');
				if (num == -1)
				{
					hashtable_0.Add(text, "");
				}
				else
				{
					string key = text.Substring(0, num);
					string value = "";
					if (num + 1 < text.Length)
					{
						value = text.Substring(num + 1);
					}
					hashtable_0.Add(key, value);
				}
			}
		}
	}
	public Class7()
	{
		
		
	}
	static Class7()
	{
		
		Class7.arrayList_0 = new System.Collections.ArrayList();
	}
}

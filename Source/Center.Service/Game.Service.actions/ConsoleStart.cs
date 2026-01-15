using Bussiness.Protocol;
using Center.Server;
using Game.Base;
using log4net;
using System;
using System.Collections;
using System.Configuration;
using System.Reflection;
namespace Game.Service.actions
{
	public class ConsoleStart : Interface0
	{
		private static readonly ILog ilog_0;
		public string HelpStr
		{
			get
			{
				return ConfigurationManager.AppSettings["HelpStr"];
			}
		}
		public string Name
		{
			get
			{
				return "--start";
			}
		}
		public string Syntax
		{
			get
			{
				return "--start [-config=./config/serverconfig.xml]";
			}
		}
		public string Description
		{
			get
			{
				return "Starts the DOL server in console mode";
			}
		}
		private static bool smethod_0()
		{
			
			return CenterServer.Instance.Start();
		}
		public void OnAction(System.Collections.Hashtable parameters)
		{
            Console.Title = "BombomHelper [6.6.0] || [Center.Service]";
            Console.ForegroundColor = ConsoleColor.Yellow;
            Console.WriteLine("--------------------------Center Service - Version 6.6.0 | By BombomHelper Team！--------------------------");
            Console.ForegroundColor = ConsoleColor.Cyan;
            Console.WriteLine(">>>>>>  Developers : ASUNA && TigerMan");
            Console.WriteLine(">>>>>>  Release Date : 1 Aralık 2025");
            Console.ForegroundColor = ConsoleColor.Green;
            CenterServer.CreateInstance(new CenterServerConfig());
			ConsoleStart.smethod_0();
			ConsoleClient consoleClient = new ConsoleClient();
			bool flag = true;
			while (flag)
			{
				try
				{
					System.Console.Write("> ");
					string text = System.Console.ReadLine();
					string[] array = text.Split(new char[]
					{
						'&'
					});
					string key;
					switch (key = array[0].ToLower())
					{
					case "exit":
						flag = false;
						continue;
					case "notice":
						if (array.Length < 2)
						{
							System.Console.WriteLine("公告需要公告内容,用&隔开!");
							continue;
						}
						CenterServer.Instance.SendSystemNotice(array[1]);
						continue;
					case "reload":
						if (array.Length < 2)
						{
							System.Console.WriteLine("加载需要指定表,用&隔开!");
							continue;
						}
						CenterServer.Instance.SendReload(array[1]);
						continue;
					case "shutdown":
						CenterServer.Instance.SendShutdown();
						continue;
					case "help":
						System.Console.WriteLine(this.HelpStr);
						continue;
					case "AAS":
						if (array.Length < 2)
						{
							System.Console.WriteLine("加载需要指定状态true or false,用&隔开!");
							continue;
						}
						CenterServer.Instance.SendAAS(bool.Parse(array[1]));
						continue;
					}
					if (text.Length > 0)
					{
						if (text[0] == '/')
						{
							text = text.Remove(0, 1);
							text = text.Insert(0, "&");
						}
						try
						{
							if (!CommandMgr.HandleCommandNoPlvl(consoleClient, text))
							{
								System.Console.WriteLine("Unknown command: " + text);
							}
						}
						catch (System.Exception ex)
						{
							System.Console.WriteLine(ex.ToString());
						}
					}
				}
				catch (System.Exception ex2)
				{
					System.Console.WriteLine("Error:" + ex2.ToString());
				}
			}
			if (CenterServer.Instance != null)
			{
				CenterServer.Instance.Stop();
			}
		}
		public void Reload(eReloadType type)
		{
		}
		public ConsoleStart()
		{
			
			
		}
		static ConsoleStart()
		{
			
			ConsoleStart.ilog_0 = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}

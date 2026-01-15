using Bussiness;
using Game.Base.Packets;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Threading;
using System.Timers;
namespace Center.Server.Managers
{
	public class MacroDropMgr
	{
		private static readonly ILog ilog_0;
		private static System.Threading.ReaderWriterLock readerWriterLock_0;
		private static System.Collections.Generic.Dictionary<int, DropInfo> dictionary_0;
		private static string string_0;
		private static int int_0;
		public static bool Init()
		{
			MacroDropMgr.readerWriterLock_0 = new System.Threading.ReaderWriterLock();
			MacroDropMgr.string_0 = System.IO.Directory.GetCurrentDirectory() + "\\macrodrop\\macroDrop.ini";
			return MacroDropMgr.Reload();
		}
		public static bool Reload()
		{
			try
			{
				System.Collections.Generic.Dictionary<int, DropInfo> dictionary = new System.Collections.Generic.Dictionary<int, DropInfo>();
				MacroDropMgr.dictionary_0 = new System.Collections.Generic.Dictionary<int, DropInfo>();
				dictionary = MacroDropMgr.smethod_3();
				if (dictionary != null && dictionary.Count > 0)
				{
					System.Threading.Interlocked.Exchange<System.Collections.Generic.Dictionary<int, DropInfo>>(ref MacroDropMgr.dictionary_0, dictionary);
				}
				return true;
			}
			catch (System.Exception ex)
			{
				if (MacroDropMgr.ilog_0.IsErrorEnabled)
				{
					MacroDropMgr.ilog_0.Error("DropInfoMgr", ex);
				}
			}
			return false;
		}
		private static void smethod_0()
		{
			MacroDropMgr.readerWriterLock_0.AcquireWriterLock(-1);
			try
			{
				foreach (System.Collections.Generic.KeyValuePair<int, DropInfo> current in MacroDropMgr.dictionary_0)
				{
					int arg_28_0 = current.Key;
					DropInfo value = current.Value;
					if (MacroDropMgr.int_0 > value.Time && value.Time > 0 && MacroDropMgr.int_0 % value.Time == 0)
					{
						value.Count = value.MaxCount;
					}
				}
			}
			catch (System.Exception ex)
			{
				if (MacroDropMgr.ilog_0.IsErrorEnabled)
				{
					MacroDropMgr.ilog_0.Error("DropInfoMgr MacroDropReset", ex);
				}
			}
			finally
			{
				MacroDropMgr.readerWriterLock_0.ReleaseWriterLock();
			}
		}
		private static void smethod_1()
		{
			bool flag = true;
			ServerClient[] allClients = CenterServer.Instance.GetAllClients();
			ServerClient[] array = allClients;
			for (int i = 0; i < array.Length; i++)
			{
				ServerClient serverClient = array[i];
				if (!serverClient.NeedSyncMacroDrop)
				{
					flag = false;
                    break;
                }
            }
					if (allClients.Length > 0 && flag)
					{
						GSPacketIn gSPacketIn = new GSPacketIn(178);
						int count = MacroDropMgr.dictionary_0.Count;
						gSPacketIn.WriteInt(count);
						MacroDropMgr.readerWriterLock_0.AcquireReaderLock(-1);
						try
						{
							foreach (System.Collections.Generic.KeyValuePair<int, DropInfo> current in MacroDropMgr.dictionary_0)
							{
								DropInfo value = current.Value;
								gSPacketIn.WriteInt(value.ID);
								gSPacketIn.WriteInt(value.Count);
								gSPacketIn.WriteInt(value.MaxCount);
							}
						}
						catch (System.Exception ex)
						{
							if (MacroDropMgr.ilog_0.IsErrorEnabled)
							{
								MacroDropMgr.ilog_0.Error("DropInfoMgr MacroDropReset", ex);
							}
						}
						finally
						{
							MacroDropMgr.readerWriterLock_0.ReleaseReaderLock();
						}
						ServerClient[] array2 = allClients;
						for (int j = 0; j < array2.Length; j++)
						{
							ServerClient serverClient2 = array2[j];
							serverClient2.NeedSyncMacroDrop = false;
							serverClient2.SendTCP(gSPacketIn);
						}
					}
					return;
				
		}
		private static void smethod_2(object sender, System.Timers.ElapsedEventArgs e)
		{
			MacroDropMgr.int_0++;
			if (MacroDropMgr.int_0 % 12 == 0)
			{
				MacroDropMgr.smethod_0();
			}
			MacroDropMgr.smethod_1();
		}
		public static void Start()
		{
			MacroDropMgr.int_0 = 0;
			System.Timers.Timer timer = new System.Timers.Timer();
			timer.Elapsed += new System.Timers.ElapsedEventHandler(MacroDropMgr.smethod_2);
			timer.Interval = 300000.0;
			timer.Enabled = true;
		}
		private static System.Collections.Generic.Dictionary<int, DropInfo> smethod_3()
		{
			System.Collections.Generic.Dictionary<int, DropInfo> dictionary = new System.Collections.Generic.Dictionary<int, DropInfo>();
			if (System.IO.File.Exists(MacroDropMgr.string_0))
			{
				IniReader iniReader = new IniReader(MacroDropMgr.string_0);
				int num = 1;
				while (iniReader.GetIniString(num.ToString(), "TemplateId") != "")
				{
					string section = num.ToString();
					int id = System.Convert.ToInt32(iniReader.GetIniString(section, "TemplateId"));
					int time = System.Convert.ToInt32(iniReader.GetIniString(section, "Time"));
					int num2 = System.Convert.ToInt32(iniReader.GetIniString(section, "Count"));
					DropInfo dropInfo = new DropInfo(id, time, num2, num2);
					dictionary.Add(dropInfo.ID, dropInfo);
					num++;
				}
				return dictionary;
			}
			return null;
		}
		public static void DropNotice(System.Collections.Generic.Dictionary<int, int> temp)
		{
			MacroDropMgr.readerWriterLock_0.AcquireWriterLock(-1);
			try
			{
				foreach (System.Collections.Generic.KeyValuePair<int, int> current in temp)
				{
					if (MacroDropMgr.dictionary_0.ContainsKey(current.Key))
					{
						DropInfo dropInfo = MacroDropMgr.dictionary_0[current.Key];
						if (dropInfo.Count > 0)
						{
							dropInfo.Count -= current.Value;
						}
					}
				}
			}
			catch (System.Exception ex)
			{
				if (MacroDropMgr.ilog_0.IsErrorEnabled)
				{
					MacroDropMgr.ilog_0.Error("DropInfoMgr CanDrop", ex);
				}
			}
			finally
			{
				MacroDropMgr.readerWriterLock_0.ReleaseWriterLock();
			}
		}
		public MacroDropMgr()
		{
			
			
		}
		static MacroDropMgr()
		{
			
			MacroDropMgr.ilog_0 = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}

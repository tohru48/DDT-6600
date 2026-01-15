using Game.Base.Config;
using log4net;
using System;
using System.IO;
using System.Reflection;
namespace Center.Server
{
	public class CenterServerConfig : BaseAppConfig
	{
		private static readonly ILog ilog_1;
		public string RootDirectory;
		[ConfigProperty("ServerID", "服务器编号", 1)]
		public int ServerID;
		[ConfigProperty("AreaID", "服务器编号", 1)]
		public int ZoneId;
		[ConfigProperty("IP", "中心服务器监听IP", "127.0.0.1")]
		public string Ip;
		[ConfigProperty("Port", "中心服务器监听端口", 9202)]
		public int Port;
		[ConfigProperty("LogConfigFile", "日志配置文件", "logconfig.xml")]
		public string LogConfigFile;
		[ConfigProperty("ScriptAssemblies", "脚本编译引用库", "")]
		public string ScriptAssemblies;
		[ConfigProperty("ScriptCompilationTarget", "脚本编译目标名称", "")]
		public string ScriptCompilationTarget;
		[ConfigProperty("LoginLapseInterval", "登陆超时时间,分钟为单位", 1)]
		public int LoginLapseInterval;
		[ConfigProperty("SystemNoticeInterval", "登陆超时时间,分钟为单位", 2)]
		public int SystemNoticeInterval;
		[ConfigProperty("SaveInterval", "数据保存周期,分钟为单位", 1)]
		public int SaveIntervalInterval;
		[ConfigProperty("SaveRecordInterval", "日志保存周期,分钟为单位", 1)]
		public int SaveRecordInterval;
		[ConfigProperty("ScanAuctionInterval", "排名行扫描周期,分钟为单位", 60)]
		public int ScanAuctionInterval;
		[ConfigProperty("ScanMailInterval", "邮件扫描周期,分钟为单位", 60)]
		public int ScanMailInterval;
		[ConfigProperty("ScanConsortiaInterval", "工会扫描周期,以分钟为单位", 60)]
		public int ScanConsortiaInterval;
		public CenterServerConfig()
		{
			
			
			this.Load(typeof(CenterServerConfig));
		}
		public void Refresh()
		{
			this.Load(typeof(CenterServerConfig));
		}
		protected override void Load(System.Type type)
		{
			if (System.Reflection.Assembly.GetEntryAssembly() != null)
			{
				this.RootDirectory = new System.IO.FileInfo(System.Reflection.Assembly.GetEntryAssembly().Location).DirectoryName;
			}
			else
			{
				this.RootDirectory = new System.IO.FileInfo(System.Reflection.Assembly.GetAssembly(type).Location).DirectoryName;
			}
			base.Load(type);
		}
		static CenterServerConfig()
		{
			
			CenterServerConfig.ilog_1 = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}

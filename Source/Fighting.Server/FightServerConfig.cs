using Game.Base.Config;
using System;
using System.Configuration;
using System.IO;
using System.Reflection;

#nullable disable
namespace Fighting.Server
{
    public class FightServerConfig : BaseAppConfig
    {
        public string LogConfigFile;
        public string RootDirectory;
        [ConfigProperty("ServerID", "服务器编号", 1)]
        public int ServerID;
        [ConfigProperty("AreaID", "服务器编号", 1)]
        public int ZoneId;
        [ConfigProperty("ServerName", "频道的名称", "7Road")]
        public string ServerName;
        [ConfigProperty("IP", "频道的IP", "127.0.0.1")]
        public string Ip;
        [ConfigProperty("Port", "频道开放端口", 9208)]
        public int Port;
        [ConfigProperty("ScriptAssemblies", "脚本编译引用库", "")]
        public string ScriptAssemblies;
        [ConfigProperty("ScriptCompilationTarget", "脚本编译目标名称", "")]
        public string ScriptCompilationTarget;

        protected override void Load(Type type)
        {
            this.RootDirectory = !(Assembly.GetEntryAssembly() != (Assembly)null) ? new FileInfo(Assembly.GetAssembly(typeof(FightServer)).Location).DirectoryName : new FileInfo(Assembly.GetEntryAssembly().Location).DirectoryName;
            base.Load(type);
        }

        public void LoadConfiguration() => this.Load(typeof(FightServerConfig));

        public void Load()
        {
            this.LogConfigFile = ConfigurationSettings.AppSettings["Logconfig"];
            this.Ip = ConfigurationSettings.AppSettings["Ip"];
            this.ServerName = ConfigurationSettings.AppSettings["ServerName"];
            this.Port = int.Parse(ConfigurationSettings.AppSettings["Port"]);
            this.ScriptCompilationTarget = ConfigurationSettings.AppSettings["ScriptAssemblies"];
            this.ZoneId = int.Parse(ConfigurationSettings.AppSettings["ServerID"]);
            this.RootDirectory = new FileInfo(Assembly.GetEntryAssembly().Location).DirectoryName;
        }
    }
}

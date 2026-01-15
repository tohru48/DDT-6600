namespace Game.Base
{
    using Game.Base.Config;
    using System;
    using System.IO;
    using System.Net;

    public class BaseServerConfiguration
    {
        protected IPAddress _ip;
        protected ushort _port;

        public BaseServerConfiguration()
        {
            this._port = 0x1b58;
            this._ip = IPAddress.Any;
        }

        protected virtual void LoadFromConfig(ConfigElement root)
        {
            string ipString = root["Server"]["IP"].GetString("any");
            if (ipString == "any")
            {
                this._ip = IPAddress.Any;
            }
            else
            {
                this._ip = IPAddress.Parse(ipString);
            }
            this._port = (ushort)root["Server"]["Port"].GetInt(this._port);
        }

        public void LoadFromXMLFile(FileInfo configFile)
        {
            XMLConfigFile root = XMLConfigFile.ParseXMLFile(configFile);
            this.LoadFromConfig(root);
        }

        protected virtual void SaveToConfig(ConfigElement root)
        {
            root["Server"]["Port"].Set(this._port);
            root["Server"]["IP"].Set(this._ip);
        }

        public void SaveToXMLFile(FileInfo configFile)
        {
            if (configFile == null)
            {
                throw new ArgumentNullException("configFile");
            }
            XMLConfigFile root = new XMLConfigFile();
            this.SaveToConfig(root);
            root.Save(configFile);
        }

        public IPAddress Ip
        {
            get
            {
                return this._ip;
            }
            set
            {
                this._ip = value;
            }
        }

        public ushort Port
        {
            get
            {
                return this._port;
            }
            set
            {
                this._port = value;
            }
        }
    }
}

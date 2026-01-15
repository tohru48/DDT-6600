namespace Game.Base.Config
{
    using log4net;
    using System;
    using System.Configuration;
    using System.Reflection;

    public abstract class BaseAppConfig
    {
        private static readonly ILog log;

        static BaseAppConfig()
        {
            log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        }

        public BaseAppConfig()
        {
        }

        protected virtual void Load(Type type)
        {
            ConfigurationManager.RefreshSection("appSettings");
            foreach (FieldInfo info in type.GetFields())
            {
                object[] customAttributes = info.GetCustomAttributes(typeof(ConfigPropertyAttribute), false);
                if (customAttributes.Length != 0)
                {
                    ConfigPropertyAttribute attrib = (ConfigPropertyAttribute)customAttributes[0];
                    info.SetValue(this, this.LoadConfigProperty(attrib));
                }
            }
        }

        private object LoadConfigProperty(ConfigPropertyAttribute attrib)
        {
            string key = attrib.Key;
            string str2 = ConfigurationManager.AppSettings[key];
            if (str2 == null)
            {
                str2 = attrib.DefaultValue.ToString();
                log.Warn("Loading " + key + " value is null,using default vaule:" + str2);
            }
            else
            {
                log.Debug("Loading " + key + " Value is " + str2);
            }
            try
            {
                return Convert.ChangeType(str2, attrib.DefaultValue.GetType());
            }
            catch (Exception exception)
            {
                log.Error("Exception in ServerProperties Load: ", exception);
                return null;
            }
        }
    }
}


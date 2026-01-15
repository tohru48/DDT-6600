namespace Game.Base.Config
{
    using System;

    [AttributeUsage(AttributeTargets.Field, AllowMultiple = false)]
    public class ConfigPropertyAttribute : Attribute
    {
        private object m_defaultValue;
        private string m_description;
        private string m_key;

        public ConfigPropertyAttribute(string key, string description, object defaultValue)
        {
            this.m_key = key;
            this.m_description = description;
            this.m_defaultValue = defaultValue;
        }

        public object DefaultValue
        {
            get
            {
                return this.m_defaultValue;
            }
        }

        public string Description
        {
            get
            {
                return this.m_description;
            }
        }

        public string Key
        {
            get
            {
                return this.m_key;
            }
        }
    }
}


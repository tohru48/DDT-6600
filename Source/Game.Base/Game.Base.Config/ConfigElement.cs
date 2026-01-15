namespace Game.Base.Config
{
    using System;
    using System.Collections;
    using System.Reflection;

    public class ConfigElement
    {
        protected Hashtable m_children;
        protected ConfigElement m_parent;
        protected string m_value;

        public ConfigElement(ConfigElement parent)
        {
            this.m_children = new Hashtable();
            this.m_parent = parent;
        }

        public bool GetBoolean()
        {
            return bool.Parse(this.m_value);
        }

        public bool GetBoolean(bool defaultValue)
        {
            if (this.m_value == null)
            {
                return defaultValue;
            }
            return bool.Parse(this.m_value);
        }

        public int GetInt()
        {
            return int.Parse(this.m_value);
        }

        public int GetInt(int defaultValue)
        {
            if (this.m_value == null)
            {
                return defaultValue;
            }
            return int.Parse(this.m_value);
        }

        public long GetLong()
        {
            return long.Parse(this.m_value);
        }

        public long GetLong(long defaultValue)
        {
            if (this.m_value == null)
            {
                return defaultValue;
            }
            return long.Parse(this.m_value);
        }

        protected virtual ConfigElement GetNewConfigElement(ConfigElement parent)
        {
            return new ConfigElement(parent);
        }

        public string GetString()
        {
            return this.m_value;
        }

        public string GetString(string defaultValue)
        {
            if (this.m_value == null)
            {
                return defaultValue;
            }
            return this.m_value;
        }

        public void Set(object value)
        {
            this.m_value = value.ToString();
        }

        public Hashtable Children
        {
            get
            {
                return this.m_children;
            }
        }

        public bool HasChildren
        {
            get
            {
                return (this.m_children.Count > 0);
            }
        }

        public ConfigElement this[string key]
        {
            get
            {
                lock (this.m_children)
                {
                    if (!this.m_children.Contains(key))
                    {
                        this.m_children.Add(key, this.GetNewConfigElement(this));
                    }
                }
                return (ConfigElement)this.m_children[key];
            }
            set
            {
                lock (this.m_children)
                {
                    this.m_children[key] = value;
                }
            }
        }

        public ConfigElement Parent
        {
            get
            {
                return this.m_parent;
            }
        }
    }
}


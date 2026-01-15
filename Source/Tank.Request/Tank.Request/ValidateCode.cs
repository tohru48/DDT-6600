using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Bussiness;

namespace Tank.Request
{
	public class ValidateCode : Page
	{
		public static Color[] colors = new Color[4]
		{
			Color.Blue,
			Color.DarkRed,
			Color.Green,
			Color.Gold
		};

		protected HtmlForm form1;

		protected Button Button1;

		protected void Page_Load(object sender, EventArgs e)
		{
			string randomcode = CheckCode.GenerateCheckCode();
			byte[] buffer = CheckCode.CreateImage(randomcode);
			base.Response.ClearContent();
			base.Response.ContentType = "image/Gif";
			base.Response.BinaryWrite(buffer);
		}

		protected void Button1_Click(object sender, EventArgs e)
		{
			CreateCheckCodeImage(GenerateCheckCode());
		}

		private string GenerateCheckCode()
		{
			string text = string.Empty;
			Random random = new Random();
			for (int i = 0; i < 4; i++)
			{
				int num = random.Next();
				text += (char)(65 + (ushort)(num % 26));
			}
			return text;
		}

		private void CreateCheckCodeImage(string checkCode)
		{
			if (checkCode == null || checkCode.Trim() == string.Empty)
			{
				return;
			}
			Bitmap bitmap = new Bitmap((int)Math.Ceiling((double)checkCode.Length * 40.5), 44);
			Graphics graphics = Graphics.FromImage(bitmap);
			try
			{
				Random random = new Random();
				Color color = colors[random.Next(colors.Length)];
				graphics.Clear(Color.Transparent);
				for (int i = 0; i < 2; i++)
				{
					int num = random.Next(bitmap.Width);
					int num2 = random.Next(bitmap.Width);
					int num3 = random.Next(bitmap.Height);
					int num4 = random.Next(bitmap.Height);
					graphics.DrawArc(new Pen(color, 2f), -num, -num3, bitmap.Width * 2, bitmap.Height, 45, 100);
				}
				Font font = new Font("Arial", 24f, FontStyle.Bold | FontStyle.Italic);
				LinearGradientBrush brush = new LinearGradientBrush(new Rectangle(0, 0, bitmap.Width, bitmap.Height), color, color, 1.2f, isAngleScaleable: true);
				graphics.DrawString(checkCode, font, brush, 2f, 2f);
				int num5 = 40;
				double num6 = Math.Sin(Math.PI * (double)num5 / 180.0);
				double num7 = Math.Cos(Math.PI * (double)num5 / 180.0);
				double num8 = Math.Atan(Math.PI * (double)num5 / 180.0);
				if (num5 > 0)
				{
					int num9 = (int)(num6 * 20.0);
					int num10 = (int)((0.0 - num6) * (double)bitmap.Width);
				}
				else
				{
					int num11 = (int)((0.0 - num6) * 22.0);
				}
				TextureBrush textureBrush = new TextureBrush(bitmap);
				textureBrush.RotateTransform(30f);
				bitmap.Save("c:\\1.jpg", ImageFormat.Png);
				MemoryStream memoryStream = new MemoryStream();
				bitmap.Save(memoryStream, ImageFormat.Png);
				base.Response.ClearContent();
				base.Response.ContentType = "image/Gif";
				base.Response.BinaryWrite(memoryStream.ToArray());
			}
			finally
			{
				graphics.Dispose();
				bitmap.Dispose();
			}
		}

		public static Bitmap KiRotate(Bitmap bmp, float angle, Color bkColor)
		{
			int num = bmp.Width + 2;
			int num2 = bmp.Height + 2;
			PixelFormat format = ((!(bkColor == Color.Transparent)) ? bmp.PixelFormat : PixelFormat.Format32bppArgb);
			Bitmap bitmap = new Bitmap(num, num2, format);
			Graphics graphics = Graphics.FromImage(bitmap);
			graphics.Clear(bkColor);
			graphics.DrawImageUnscaled(bmp, 1, 1);
			graphics.Dispose();
			GraphicsPath graphicsPath = new GraphicsPath();
			graphicsPath.AddRectangle(new RectangleF(0f, 0f, num, num2));
			Matrix matrix = new Matrix();
			matrix.Rotate(angle);
			RectangleF bounds = graphicsPath.GetBounds(matrix);
			Bitmap bitmap2 = new Bitmap((int)bounds.Width, (int)bounds.Height, format);
			graphics = Graphics.FromImage(bitmap2);
			graphics.Clear(bkColor);
			graphics.TranslateTransform(0f - bounds.X, 0f - bounds.Y);
			graphics.RotateTransform(angle);
			graphics.InterpolationMode = InterpolationMode.HighQualityBilinear;
			graphics.DrawImageUnscaled(bitmap, 0, 0);
			graphics.Dispose();
			bitmap.Dispose();
			return bitmap2;
		}
	}
}

// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.SimpleNpcAi
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class SimpleNpcAi : ABrain
  {
    protected Player m_targer;
    private static Random random = new Random();
    private static string[] listChat = new string[13]
    {
      "为了荣誉！为了胜利！！",
      "握紧手中的武器，不要发抖呀～",
      "为了国王而战！",
      "敌人就在眼前，大家做好战斗准备！",
      "感觉最近国王的行为举止越来越反常......",
      "为了啵咕的胜利！！兄弟们冲啊！",
      "快消灭敌人！",
      "大家一起上,人多力量大！",
      "大家一起速战速决！",
      "包围敌人，歼灭他们。",
      "增援！增援！我们需要更多的增援！！",
      "就算牺牲自己，也不会让你们轻易得逞。",
      "不要轻视啵咕的力量，否则你会为此付出代价。"
    };

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.m_body.CurrentDamagePlus = 1f;
      this.m_body.CurrentShootMinus = 1f;
      if (!this.m_body.IsSay)
        return;
      this.m_body.Say(SimpleNpcAi.GetOneChat(), 0, this.Game.Random.Next(0, 5000));
    }

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      base.OnStartAttacking();
      this.m_targer = this.Game.FindNearestPlayer(this.Body.X, this.Body.Y);
      this.Beating();
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    public void MoveToPlayer(Player player)
    {
      int num1 = (int) player.Distance(this.Body.X, this.Body.Y);
      int num2 = this.Game.Random.Next(((SimpleNpc) this.Body).NpcInfo.MoveMin, ((SimpleNpc) this.Body).NpcInfo.MoveMax);
      if (num1 <= 97)
        return;
      int num3 = num1 <= ((SimpleNpc) this.Body).NpcInfo.MoveMax ? num1 - 90 : num2;
      if (player.Y < 420 && player.X < 210)
      {
        if (this.Body.Y > 420)
        {
          if (this.Body.X - num3 < 50)
            this.Body.MoveTo(25, this.Body.Y, "walk", 1200, "", ((SimpleNpc) this.Body).NpcInfo.speed, new LivingCallBack(this.Jump));
          else
            this.Body.MoveTo(this.Body.X - num3, this.Body.Y, "walk", 1200, "", ((SimpleNpc) this.Body).NpcInfo.speed, new LivingCallBack(this.MoveBeat));
        }
        else if (player.X > this.Body.X)
          this.Body.MoveTo(this.Body.X + num3, this.Body.Y, "walk", 1200, "", ((SimpleNpc) this.Body).NpcInfo.speed, new LivingCallBack(this.MoveBeat));
        else
          this.Body.MoveTo(this.Body.X - num3, this.Body.Y, "walk", 1200, "", ((SimpleNpc) this.Body).NpcInfo.speed, new LivingCallBack(this.MoveBeat));
      }
      else if (this.Body.Y < 420)
      {
        if (this.Body.X + num3 > 200)
          this.Body.MoveTo(200, this.Body.Y, "walk", 1200, "", ((SimpleNpc) this.Body).NpcInfo.speed, new LivingCallBack(this.Fall));
      }
      else if (player.X > this.Body.X)
        this.Body.MoveTo(this.Body.X + num3, this.Body.Y, "walk", 1200, "", ((SimpleNpc) this.Body).NpcInfo.speed, new LivingCallBack(this.MoveBeat));
      else
        this.Body.MoveTo(this.Body.X - num3, this.Body.Y, "walk", 1200, "", ((SimpleNpc) this.Body).NpcInfo.speed, new LivingCallBack(this.MoveBeat));
    }

    public void MoveBeat() => this.Body.Beat((Living) this.m_targer, "beatA", 100, 0, 0, 1, 1);

    public void FallBeat() => this.Body.Beat((Living) this.m_targer, "beatA", 100, 0, 2000, 1, 1);

    public void Jump()
    {
      this.Body.Direction = 1;
      this.Body.JumpTo(this.Body.X, this.Body.Y - 240, nameof (Jump), 0, 2, 3, new LivingCallBack(this.Beating));
    }

    public void Beating()
    {
      if (this.m_targer == null || this.Body.Beat((Living) this.m_targer, "beatA", 100, 0, 0, 1, 1))
        return;
      this.MoveToPlayer(this.m_targer);
    }

    public void Fall()
    {
      this.Body.FallFrom(this.Body.X, this.Body.Y + 240, (string) null, 0, 0, 12, new LivingCallBack(this.Beating));
    }

    public static string GetOneChat()
    {
      int index = SimpleNpcAi.random.Next(0, SimpleNpcAi.listChat.Length);
      return SimpleNpcAi.listChat[index];
    }

    public static void LivingSay(List<Living> livings)
    {
      if (livings == null || livings.Count == 0)
        return;
      int count = livings.Count;
      foreach (Living living in livings)
        living.IsSay = false;
      int length = count > 5 ? (count <= 5 || count > 10 ? SimpleNpcAi.random.Next(1, 4) : SimpleNpcAi.random.Next(1, 3)) : SimpleNpcAi.random.Next(0, 2);
      if (length <= 0)
        return;
      int[] numArray = new int[length];
      int num = 0;
      while (num < length)
      {
        int index = SimpleNpcAi.random.Next(0, count);
        if (!livings[index].IsSay)
        {
          livings[index].IsSay = true;
          int delay = SimpleNpcAi.random.Next(0, 5000);
          livings[index].Say(SimpleNpcAi.GetOneChat(), 0, delay);
          ++num;
        }
      }
    }
  }
}

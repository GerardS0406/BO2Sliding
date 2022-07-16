init()
{
	level thread on_player_connect();
}

on_player_connect()
{
	level endon("end_game");
	while(1)
	{
		level waittill("connected", player);
		player thread ready_to_slide();
	}
}

ready_to_slide()
{
	self.is_sliding = false;
	self.is_ready_to_slide = true;
	while(1)
	{
		if(self IsSprinting() && self IsOnGround())
		{
			while(self IsSprinting())
			{
				wait .01;
			}
			if(!self IsOnGround())
			{
				while(!self IsOnGround())
				{
					wait .01;
				}
			}
			self knee_slide();
		}
		wait .01;
	}
}

knee_slide()
{
	if(self GetStance() == "crouch" && !self.is_sliding && self.is_ready_to_slide && self IsOnGround())
	{
		self.is_sliding = true;
		self.ready_to_slide = false;
		self.is_drinking = 1;
		self SetStance( "crouch" );
		self AllowProne(false);
		//self AllowStand(false);
		self AllowAds(false);
		self AllowMelee(false);
		self do_knee_slide(300,1);
		self.is_drinking = undefined;
		self.is_sliding = false;
		self AllowAds(true);
		self AllowMelee(true);
		self AllowProne(true);
		//self AllowStand(true);
		self.ready_to_slide = true;
	}
}

do_knee_slide(force,time)
{
	angles = self GetPlayerAngles();
	angles = (0,(angles[1]),0);
	vec = AnglesToForward(angles);
	i = 0;
	time = time*0.18;
	dist = 20;
	while(i < time && self IsOnGround() && dist > 5)
	{
		if(self GetStance() == "stand")
		{
			self thread doAJump();
			return;
		}
		mo = self.origin;
		i += 0.01;
		wait 0.01;
		self SetVelocity(vec * force);
		dist = Distance(mo, self.origin);
	}
}

doAJump()
{
	direction = AnglesToUp((0,self GetPlayerAngles()[1],0) * 2000);
	self SetOrigin(self.origin + (0,0,5));
	self SetVelocity( self GetVelocity() + (0,0,250) );
	wait .1;
	while(!self IsOnGround())
	{
		wait .01;
	}
	self knee_slide();
}

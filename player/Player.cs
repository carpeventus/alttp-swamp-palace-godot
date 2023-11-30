using Godot;
using System;

public partial class Player : CharacterBody2D {
	[Export] public float MoveSpeed = 60f;

	private AnimationTree _animationTree;
	public Vector2 InputDirection { get; private set; }
	public Vector2 InputOriginal { get; private set; }
	public Vector2 FaceDirection { get; private set; }
	public override void _Ready() {
		_animationTree = GetNode<AnimationTree>("AnimationTree");
		_animationTree.Active = true;
		InitFaceSouth();
	}

	public override void _PhysicsProcess(double delta) {
		Velocity = InputDirection.Normalized() * MoveSpeed;
		MoveAndSlide();
	}
	public override void _Process(double delta) {
		InputOriginal = Input.GetVector("move_left", "move_right", "move_up", "move_down");
		InputDirection = InputOriginal.Normalized();
		UpdateCurrentFaceDirection();
		UpdateAnimationParams();
	}

	private void InitFaceSouth() {
		_animationTree.Set("parameters/conditions/idle", true);
		_animationTree.Set("parameters/conditions/moving", false);
		_animationTree.Set("parameters/Idle/blend_position", Vector2.Down);
		_animationTree.Set("parameters/Walk/blend_position", Vector2.Zero);
		FaceDirection = Vector2.Down;
	}

	private void UpdateAnimationParams() {
		if (Velocity.Length() > 0) {
			_animationTree.Set("parameters/conditions/idle", false);
			_animationTree.Set("parameters/conditions/moving", true);
		}
		else {
			_animationTree.Set("parameters/conditions/idle", true);
			_animationTree.Set("parameters/conditions/moving", false);
		}

		if (InputDirection != Vector2.Zero) {
			_animationTree.Set("parameters/Idle/blend_position", InputDirection);
			_animationTree.Set("parameters/Walk/blend_position", InputDirection);
		}
	}

	private void UpdateCurrentFaceDirection() {
		if (InputDirection == Vector2.Zero) {
			return;
		}
		// 先判定左右，我们规定当同时按上和右时，最终呈现朝右的动画；总之，同时按下多个方向时，左右优先于上下的动画
		if (InputDirection.X > 0) {
			FaceDirection = Vector2.Right;
		}
		else if (InputDirection.X < 0) {
			FaceDirection = Vector2.Left;
		}
		else if (InputDirection.Y > 0) {
			FaceDirection = Vector2.Down;
		}
		else if (InputDirection.Y < 0){
			FaceDirection = Vector2.Up;
		}
	}
}

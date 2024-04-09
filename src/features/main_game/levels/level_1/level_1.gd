extends Control

const UITrait: Resource = preload("res://features/main_game/UI/traits/trait.gd")

var _tutorial: GameTutorial
var _first_slide_builder: GameTutorialSlideBuilder

func _ready() -> void:
	self._tutorial_setup()
	$UI.tutorial_button.pressed.connect(self._tutorial_start)


func _tutorial_setup() -> void:
	var entity_trait_list: Control = $UI.entity_trait_list
	var trait_shop: Control = $UI.trait_menu
	var trait_shop_points_preview: Control = trait_shop.points_preview_label
	var start_pause_button: Control = $UI.start_pause_button
	
	var first_spider: EntityGD
	for enemy: EntityGD in $Entitymanager.enemies():
		if enemy is EntitySpider:
			first_spider = enemy
			break
	
	var first_player: EntityGD = $Entitymanager.players()[0]
	
	var asexual_trait: UITrait
	for ui_trait: UITrait in trait_shop.traits():
		if ui_trait.display_name == "Asexual":
			asexual_trait = ui_trait
			break

	self._tutorial = GameTutorial.create()
	self._tutorial.closed.connect(self._tutorial_close)
	
	self._first_slide_builder = self._tutorial.create_head_slide() \
		.set_title("Entity Traits") \
		.set_description(
			"All entities in the game have 'traits'.\n\n" + \
			"These traits modify the behavior of\nentities in predictable ways."
		) \
		.add_arrow_relative_to(entity_trait_list, GameTutorialSlideBuilder.Direction.BELOW) \
		.position_relative_to(entity_trait_list, GameTutorialSlideBuilder.Direction.BELOW) \
		.on_open(func (_slide: GameTutorialSlide) -> void:
			$Entitymanager.disable_entity_hover = true
			$Entitymanager.show_traits.emit(first_spider)
			) \
		.on_close(func () -> void:
			$Entitymanager.disable_entity_hover = false
			$Entitymanager.end_show_traits.emit()
			)
			
	var second_slide: GameTutorialSlideBuilder = self._first_slide_builder.next_slide() \
		.set_title("The Trait Shop") \
		.set_description("Traits can be purchased from the shop\nand applied to specific entities.") \
		.add_arrow_relative_to(trait_shop, GameTutorialSlideBuilder.Direction.LEFT_OF) \
		.position_relative_to(trait_shop, GameTutorialSlideBuilder.Direction.LEFT_OF)
	
	var third_slide: GameTutorialSlideBuilder = second_slide.next_slide() \
		.set_title("Trait Points") \
		.set_description("Using any traits from the shop\nwill deduct points from the total.") \
		.add_arrow_relative_to(trait_shop_points_preview, GameTutorialSlideBuilder.Direction.ABOVE_LEFT) \
		.position_relative_to(trait_shop_points_preview, GameTutorialSlideBuilder.Direction.ABOVE_LEFT)
		
	var fourth_slide: GameTutorialSlideBuilder = third_slide.next_slide() \
		.set_title("The Player") \
		.set_description(
			"This is the player entity.\n\n" + \
			"You are able to add traits to\nthis entity from the shop."
		) \
		.add_arrow_relative_to(first_player, GameTutorialSlideBuilder.Direction.ABOVE) \
		.position_relative_to(first_player, GameTutorialSlideBuilder.Direction.ABOVE)
	
	var fifth_slide: GameTutorialSlideBuilder = fourth_slide.next_slide() \
		.set_title("Adding Traits") \
		.set_description("Try dragging and dropping the 'Asexual'\ntrait on to the player.") \
		.add_arrow_relative_to(first_player, GameTutorialSlideBuilder.Direction.ABOVE) \
		.add_arrow_relative_to(asexual_trait, GameTutorialSlideBuilder.Direction.LEFT_OF) \
		.position_relative_to(asexual_trait, GameTutorialSlideBuilder.Direction.LEFT_OF) \
		.on_process(func (slide: GameTutorialSlide) -> void:
			if first_player.has_trait("reproduction"):
				slide.description_label.text = "Great job!"
				slide.next_slide_button.visible = true
			else:
				slide.next_slide_button.visible = false
			)
	
	var sixth_slide: GameTutorialSlideBuilder = fifth_slide.next_slide() \
		.set_title("Adding Traits") \
		.set_description("Try adding more traits to the player.") \
		.add_arrow_relative_to(first_player, GameTutorialSlideBuilder.Direction.ABOVE) \
		.add_arrow_relative_to(trait_shop, GameTutorialSlideBuilder.Direction.LEFT_OF) \
		.position_relative_to(trait_shop, GameTutorialSlideBuilder.Direction.LEFT_OF) \
		.on_open(func (slide: GameTutorialSlide) -> Callable:
			slide.next_slide_button.visible = false
			
			var temporary_handler: Callable = func () -> void:
				slide.description_label.text = "Great job!"
				slide.next_slide_button.visible = true
			
			first_player.traits_changed.connect(temporary_handler)
			
			return func() -> void:
				first_player.traits_changed.disconnect(temporary_handler)
			)
	
	var _seventh_slide: GameTutorialSlideBuilder = sixth_slide.next_slide() \
		.set_title("Toggle the Simulation") \
		.set_description(
			"This button starts and stops the simulation.\n\n" + \
			"Click it to see your player battle!"
		) \
		.add_arrow_relative_to(start_pause_button, GameTutorialSlideBuilder.Direction.BELOW_LEFT) \
		.position_relative_to(start_pause_button, GameTutorialSlideBuilder.Direction.BELOW_LEFT) \
		.on_open(func (_slide: GameTutorialSlide) -> void:
			$UI.start_pause_button.disabled = false
			) \
		.on_process(func (slide: GameTutorialSlide) -> void:
			if not $Entitymanager.paused:
				slide._tutorial.close()
			)
	
func _tutorial_start() -> void:
	$Entitymanager.paused = true
	$UI.start_pause_button.disabled = true
	self._tutorial.set_slide(self._first_slide_builder.build())
	self.add_child(self._tutorial)

func _tutorial_close(_tutorial: GameTutorial) -> void:
	$UI.start_pause_button.disabled = false
	

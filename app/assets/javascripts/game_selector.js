/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
class GameSelector {
  constructor(sel = '.autocomplete') {
    logger.debug("GameSelector.constructor", sel);
    $(sel).autocomplete({
      minLength: 3,
      delay: 500,
      source: this.query.bind(this),
      select: this.onSelect.bind(this)
    });
  }

  query(query, process) {
    logger.debug("GameSelector.query", query, process);
    this.callback = process;
    this.abort();
    this.xhr = $.get('/game/index', { query: query['term'], format: 'json' }, this.process.bind(this));
  }

  process(data, status, xhr) {
    logger.debug("GameSelector.process", data, status, xhr);
    this.data = data;
    this.resetGame();
    this.callback(data);
  }

  resetGame() {
    logger.debug("GameSelector.resetGame");
    $('#playing_bgg_id').val('');
  }

  onSelect(event, ui) {
    logger.debug('GameSelector.onSelect', event, ui);
    this.abort();
    logger.debug('GameSelector.onSelect game:', $('#playing_game'), ui.item['label']);
    logger.debug('GameSelector.onSelect bgg_id:', $('#playing_bgg_id'), ui.item['value']);
    const bgg_id = ui.item['value'];
    $('#playing_bgg_id').val(bgg_id);
    const game_name = this.getGameName(bgg_id, ui.item['label']);
    $('#playing_game').val(game_name);

    return false;
  }

  getGameName(bgg_id, default_name) {
    const bgg_game = this.getLabel(bgg_id);
    if (bgg_game && bgg_game.name) {
      return bgg_game.name;
    }
    return default_name;
  }

  abort() {
    logger.debug("GameSelector.abort", this.xhr);
    if (this.xhr) { this.xhr.abort(); }
  }

  getLabel(bgg_id) {
    logger.debug('GameSelector.getLabel', bgg_id);
    return _.find(this.data, game => game.value === bgg_id);
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).GameSelector = GameSelector;

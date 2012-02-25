// $Id: feedback.js,v 1.3.2.2 2010/01/08 22:21:11 sun Exp $

/**
 * Attach auto-submit to admin view form.
 */
Drupal.behaviors.feedbackAdminForm = function (context) {
  $('#feedback-admin-view-form:not(.feedback-processed)', context).addClass('feedback-processed').each(function () {
    $(this).find('fieldset.feedback-messages :input[type="checkbox"]').click(function () {
      this.form.submit();
    });
  });
};

/**
 * Attach collapse behavior to the feedback form block (once).
 */
Drupal.behaviors.feedbackForm = function (context) {
  $('#block-feedback-form:not(.feedback-processed)', context).addClass('feedback-processed').each(function () {
    var $block = $(this);
    $block.find('span.feedback-link')
      .prepend('<span id="feedback-form-toggle">[ + ]</span> ')
      .css('cursor', 'pointer')
      .toggle(function () {
          Drupal.feedbackFormToggle($block, false);
        },
        function() {
          Drupal.feedbackFormToggle($block, true);
        }
      );
    $block.find('form').hide()
      .find(':input[name="ajax"]').val(1).end()
      .submit(function() {
        // Toggle throbber/button.
        $('#feedback-throbber', this).addClass('throbbing');
        $('#feedback-submit', this).fadeOut('fast', function () {
          Drupal.feedbackFormSubmit($(this).parents('form'));
        });
        return false;
      });
    $block.show();
  });
};

/**
 * Collapse or uncollapse the feedback form block.
 */
Drupal.feedbackFormToggle = function ($block, enable) {
  $block.find('form').slideToggle('medium');
  if (enable) {
    $('#feedback-form-toggle', $block).html('[ + ]');
  }
  else {
    $('#feedback-form-toggle', $block).html('[ &minus; ]');
  }
};

/**
 * Collapse or uncollapse the feedback form block.
 */
Drupal.feedbackFormSubmit = function ($form) {
  $.post($form.get(0).action, $form.serialize(), function (data) {
    // Collapse the form.
    $('#block-feedback-form').find('.feedback-link').click();
    // Display status message.
    $form.parent().parent().append('<div id="feedback-status-message">' + data.message + '</div>');
    // Reset form values.
    $(':input[name="message"]', $form).val('');
    $('#feedback-throbber', $form).removeClass('throbbing');
    $('#feedback-submit', $form).show();
    // Blend out status message.
    window.setTimeout(function () {
      $('#feedback-status-message').fadeOut('slow', function () {
        $(this).remove();
      });
    }, 3000);
  }, 'json');
  return false;
};


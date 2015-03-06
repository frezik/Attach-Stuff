# Copyright (c) 2015  Timm Murray
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met:
# 
#     * Redistributions of source code must retain the above copyright notice, 
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright 
#       notice, this list of conditions and the following disclaimer in the 
#       documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.
package Attach::Stuff;

# ABSTRACT: Attach stuff to other stuff
use v5.14;
use warnings;
use Moose;
use namespace::autoclean;
use SVG;

# According to SVG spec, there are 3.543307 pixels per mm.  See:
# http://www.w3.org/TR/SVG/coords.html#Units
use constant MM_IN_PX  => 3.543307;

has 'width' => (
    is       => 'rw',
    isa      => 'Num',
    required => 1,
);
has 'height' => (
    is       => 'rw',
    isa      => 'Num',
    required => 1,
);
has 'screw_default_radius' => (
    is       => 'rw',
    isa      => 'Num',
    required => 1,
);
has 'screw_holes' => (
    is       => 'rw',
    isa      => 'ArrayRef[ArrayRef[Num]]',
    required => 1,
);


sub draw
{
    my ($self) = @_;
    my $width                = $self->width;
    my $height               = $self->height;
    my $screw_default_radius = $self->screw_default_radius;
    my @screw_holes          = @{ $self->screw_holes };

    my $svg = SVG->new(
        width  => $self->_mm_to_px( $width ),
        height => $self->_mm_to_px( $height ),
    );

    my $draw = $svg->group(
        id    => 'draw',
        style => {
            stroke         => 'black',
            'stroke-width' => 0.1,
            fill           => 'none',
        },
    );

    # Draw outline
    $draw->rectangle(
        x      => 0,
        y      => 0,
        width  => $self->_mm_to_px( $width ),
        height => $self->_mm_to_px( $height ),
    );

    # Draw screw holes
    $draw->circle(
        cx => $self->_mm_to_px( $_->[0] ),
        cy => $self->_mm_to_px( $_->[1] ),
        r  => $self->_mm_to_px( $screw_default_radius ),
    ) for @screw_holes;

    return $svg;
}


sub _mm_to_px
{
    my ($self, $mm) = @_;
    return $mm * MM_IN_PX;
}


no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

=head1 NAME

  Attach::Stuff - Attach stuff to other stuff

=cut
